import Network

struct LogicConstant {

    struct Browsers {
        static let browserNames: Set<String> = [
            "about", "arc", "chrome", "brave", "edge", "viva", "vivaldi", "opera", "file",
        ]
        static let browserSites: Set<String> = [
            "com.google.Chrome",
            "com.apple.Safari",
            "com.brave.Browser",
            "com.microsoft.edgemac",
            "company.thebrowser.Browser",
            "com.operasoftware.Opera",
            "com.vivaldi.Vivaldi",
        ]
        static let newTabPrefixes: [String] = [
            "new tab",
            "start page",
            "startpage",
            "about:blank",
            "about:newtab",
            "chrome://newtab",
            "brave://newtab",
            "edge://newtab",
            "arc://newtab",
            "vivaldi://newtab",
            "opera://startpage",
            "favorites://",
            "topsites://",
        ]

    }

    struct Server {
        static let PORT: NWEndpoint.Port = 10000
        static let html = """
            <!DOCTYPE html>
            <html>
            <head>
                <style>
                    body {
                        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                        background-color: #f2f2f7;
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        justify-content: center;
                        height: 100vh;
                        margin: 0;
                        color: #1c1c1e;
                    }
                    .container {
                        text-align: center;
                        background: white;
                        padding: 40px;
                        border-radius: 20px;
                        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                    }
                    h1 { font-size: 32px; margin-bottom: 10px; color: #ff3b30; }
                    p { font-size: 18px; color: #8e8e93; }
                    .logo { font-size: 60px; margin-bottom: 20px; }
                    @media (prefers-color-scheme: dark) {
                        body { background-color: #1c1c1e; color: #f2f2f7; }
                        .container { background: #2c2c2e; box-shadow: 0 4px 12px rgba(0,0,0,0.3); }
                        p { color: #aeaeb2; }
                    }
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="logo">🛡️</div>
                    <h1>Focus Mode Active</h1>
                    <p>This site is blocked by Free.</p>
                    <p>Get back to work!</p>
                </div>
            </body>
            </html>
            """
        static let server_response = """
            HTTP/1.1 200 OK\r
            Content-Type: text/html\r
            Content-Length: \(Server.html.utf8.count)\r
            Connection: close\r
            \r
            \(Server.html)
            """
    }

}
