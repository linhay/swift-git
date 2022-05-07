public struct RebaseOptions: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
}

public extension RebaseOptions {

    ///  --abort
static let abort: Self = "--abort"
    ///  --allow-empty-message
static let allowEmptyMessage: Self = "--allow-empty-message"
    ///  --apply
static let apply: Self = "--apply"
    ///  --autosquash
static let autosquash: Self = "--autosquash"
    ///  --autostash
static let autostash: Self = "--autostash"
    ///  --committer-date-is-author-date
static let committerDateIsAuthorDate: Self = "--committer-date-is-author-date"
    ///  --continue
static let `continue`: Self = "--continue"
    ///  --edit-todo
static let editTodo: Self = "--edit-todo"
    ///  --empty={drop,keep,ask}
    static func emptyDropKeepAsk() -> Self { .init("--empty{drop,keep,ask}=") }
    ///  --exec <cmd>
    static func exec(_ cmd: String) -> Self { .init("--exec \(cmd)") }
    ///  --force-rebase
static let forceRebase: Self = "--force-rebase"
    ///  --fork-point
static let forkPoint: Self = "--fork-point"
    ///  --gpg-sign[=<keyid>]
    static func gpgSign(_ keyid: [String]) -> Self { .init("--gpg-sign=\(keyid.joined(separator: ","))") }
    ///  --ignore-date
static let ignoreDate: Self = "--ignore-date"
    ///  --ignore-whitespace
static let ignoreWhitespace: Self = "--ignore-whitespace"
    ///  --interactive
static let interactive: Self = "--interactive"
    ///  --keep-base
static let keepBase: Self = "--keep-base"
    ///  --keep-empty
static let keepEmpty: Self = "--keep-empty"
    ///  --merge
static let merge: Self = "--merge"
    ///  --no-autosquash
static let noAutosquash: Self = "--no-autosquash"
    ///  --no-autostash
static let noAutostash: Self = "--no-autostash"
    ///  --no-ff
static let noFf: Self = "--no-ff"
    ///  --no-fork-point
static let noForkPoint: Self = "--no-fork-point"
    ///  --no-gpg-sign
static let noGpgSign: Self = "--no-gpg-sign"
    ///  --no-keep-empty
static let noKeepEmpty: Self = "--no-keep-empty"
    ///  --no-reapply-cherry-picks
static let noReapplyCherryPicks: Self = "--no-reapply-cherry-picks"
    ///  --no-rerere-autoupdate
static let noRerereAutoupdate: Self = "--no-rerere-autoupdate"
    ///  --no-reschedule-failed-exec
static let noRescheduleFailedExec: Self = "--no-reschedule-failed-exec"
    ///  --no-stat
static let noStat: Self = "--no-stat"
    ///  --no-verify
static let noVerify: Self = "--no-verify"
    ///  --onto <newbase>
    static func onto(_ newbase: String) -> Self { .init("--onto \(newbase)") }
    ///  --quiet
static let quiet: Self = "--quiet"
    ///  --quit
static let quit: Self = "--quit"
    ///  --reapply-cherry-picks
static let reapplyCherryPicks: Self = "--reapply-cherry-picks"
    ///  --rerere-autoupdate
static let rerereAutoupdate: Self = "--rerere-autoupdate"
    ///  --reschedule-failed-exec
static let rescheduleFailedExec: Self = "--reschedule-failed-exec"
    ///  --reset-author-date
static let resetAuthorDate: Self = "--reset-author-date"
    ///  --root
static let root: Self = "--root"
    ///  --show-current-patch
static let showCurrentPatch: Self = "--show-current-patch"
    ///  --signoff
static let signoff: Self = "--signoff"
    ///  --skip
static let skip: Self = "--skip"
    ///  --stat
static let stat: Self = "--stat"
    ///  --strategy-option=<strategy-option>
    static func strategyOption(_ strategyOption: String) -> Self { .init("--strategy-option=\(strategyOption)") }
    ///  --strategy=<strategy>
    static func strategy(_ strategy: String) -> Self { .init("--strategy=\(strategy)") }
    ///  --verbose
static let verbose: Self = "--verbose"
    ///  --verify
static let verify: Self = "--verify"
    ///  --whitespace=<option>
    static func whitespace(_ option: String) -> Self { .init("--whitespace=\(option)") }
enum Rebasemerges: String {
case rebaseCousins = "rebase-cousins"
case noRebaseCousins = "no-rebase-cousins"
}
    ///  --rebase-merges[=(rebase-cousins|no-rebase-cousins)]
    static func rebaseMerges(_ rebaseMerges: Rebasemerges) -> Self { .init("--rebase-merges[]=\(rebaseMerges.rawValue)") }

}