What you have

- 195 Swift files, AppKit UI, Combine state, 46 coordinator/service enums
- Core logic is solid (engines are pure, well-tested at 98% coverage)
- Main pain points: AppKit boilerplate, Combine complexity, coordinator sprawl

---

Key questions before committing to a plan

1. SwiftUI? — The biggest win would be migrating the UI from AppKit to SwiftUI. macOS 14+ support would unlock most needed APIs (MenuBarExtra, NavigationSplitView, etc.)
2. Architecture simplification? — The coordinator enum pattern (46 services) feels over-engineered. Swift's structured concurrency + @Observable could simplify significantly.
3. What's the target macOS? — This affects which SwiftUI APIs are available.

---

Suggested rewrite phases

Phase 1 — Stabilize the domain model

Keep the pure logic layer (engines: PomodoroEngine, ScheduleEngine, PauseEngine) — these are well-tested and correct. Refactor them to be standalone, framework-free structs with no Combine
dependency.

Phase 2 — Replace AppState + Combine with @Observable

Collapse the 46 coordinator/service files into a leaner AppStore using Swift's @Observable macro and async/await. One observable object driving the whole app, mutations via async methods.

Phase 3 — Rewrite UI in SwiftUI

Replace all NSViewController subclasses with SwiftUI views. Use MenuBarExtra for the status bar, NavigationSplitView for sidebar + content.

Phase 4 — Simplify system integrations

BrowserMonitor and LocalServer can stay mostly as-is (they're isolated). Wrap them with async streams instead of timer-based polling.

---

What would stay the same

- Feature set (blocking, schedules, pomodoro, pause, calendar)
- Models (Schedule, RuleSet, etc.)
- Pure engine structs
- System entitlements / browser automation

---

What's driving the rewrite? Knowing whether it's "too much boilerplate", "hard to add features", "want SwiftUI", or something else would help me sharpen the plan.
