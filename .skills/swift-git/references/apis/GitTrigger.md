# GitTrigger

Location: Sources/SwiftGit/Custom/GitTrigger.swift

Public declaration highlights
- public struct GitTrigger
- public enum Event: Int { case beforeRun, afterRun }
- public struct Content { public let commands: [String]; public let data: Data }
- public init(on event: Event, action: @escaping (_ result: Result<Content, Error>) -> Void)
- public static func failure(on:event, action: ...) and success(on:event, action: ...)

Summary
Small event/callback primitive used by GitEnvironment to invoke actions before or after certain events. Useful for logging, telemetry, or validation hooks.

Usage example

  let trigger = GitTrigger(on: .beforeRun) { result in
     switch result { case .success(let content): print(content.commands) case .failure(let err): print(err) }
  }

Notes for agents
- When constructing GitEnvironment for tests, pass triggers to observe command execution events.
