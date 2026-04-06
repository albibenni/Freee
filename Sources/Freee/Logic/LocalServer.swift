import Foundation
import Network

protocol LocalServerConnection {
    func start(queue: DispatchQueue)
    func receive(
        minimumIncompleteLength: Int,
        maximumLength: Int,
        completion: @escaping (_ data: Data?, _ isComplete: Bool, _ error: NWError?) -> Void
    )
    func send(content: Data?, completion: @escaping (NWError?) -> Void)
    func cancel()
}

private final class LocalServerNWConnectionAdapter: LocalServerConnection {
    private let base: NWConnection

    init(base: NWConnection) {
        self.base = base
    }

    func start(queue: DispatchQueue) {
        base.start(queue: queue)
    }

    func receive(
        minimumIncompleteLength: Int,
        maximumLength: Int,
        completion: @escaping (_ data: Data?, _ isComplete: Bool, _ error: NWError?) -> Void
    ) {
        base.receive(
            minimumIncompleteLength: minimumIncompleteLength,
            maximumLength: maximumLength
        ) { data, _, isComplete, error in
            completion(data, isComplete, error)
        }
    }

    func send(content: Data?, completion: @escaping (NWError?) -> Void) {
        base.send(content: content, completion: .contentProcessed(completion))
    }

    func cancel() {
        base.cancel()
    }
}

class LocalServer {
    var listener: NWListener?
    private(set) var port: NWEndpoint.Port?
    var onFailure: ((Error) -> Void)?
    var processNameProvider: () -> String = { ProcessInfo.processInfo.processName }
    var listenerFactory: (_ port: NWEndpoint.Port) throws -> NWListener = { port in
        try NWListener(using: .tcp, on: port)
    }

    func start(on requestedPort: NWEndpoint.Port = LogicConstant.Server.PORT) {
        let isGeneralTesting =
            processNameProvider().contains("Test") && requestedPort == LogicConstant.Server.PORT

        if isGeneralTesting {
            return
        }

        do {
            let listener = try listenerFactory(requestedPort)
            self.port = requestedPort

            listener.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    _ = listener.port
                case .failed(let error):
                    self.onFailure?(error)
                default:
                    break
                }
            }

            listener.newConnectionHandler = { connection in
                self.handleConnection(LocalServerNWConnectionAdapter(base: connection))
            }

            listener.start(queue: .global())
            self.listener = listener
        } catch {
            self.onFailure?(error)
        }
    }

    func stop() {
        listener?.cancel()
        listener = nil
        port = nil
    }

    func handleConnection(_ connection: LocalServerConnection) {
        connection.start(queue: .global())

        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { _, isComplete, _ in
            if isComplete {
                connection.cancel()
            } else {
                connection.send(content: LogicConstant.Server.server_response.data(using: .utf8)) {
                    _ in
                    connection.cancel()
                }
            }
        }
    }
}
