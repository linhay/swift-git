import XCTest
@testable import SwiftGit
import Stem
import Combine

final class SwiftGitTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func testVersion() async throws {
        let output = try await Git.shared.version()
        assert(STVersion(output) != nil)
        try Git.shared.versionPublisher().sink { _ in
            
        } receiveValue: { str in
            assert(output == str)
        }.store(in: &cancellables)
    }
    
    func testHelp() async throws {
        let output = try await Git.shared.help()
        let text = "usage: git [--version] [--help] [-C <path>] [-c <name>=<value>]\n           [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]\n           [-p | --paginate | -P | --no-pager] [--no-replace-objects] [--bare]\n           [--git-dir=<path>] [--work-tree=<path>] [--namespace=<name>]\n           [--super-prefix=<path>] [--config-env=<name>=<envvar>]\n           <command> [<args>]\n\nThese are common Git commands used in various situations:\n\nstart a working area (see also: git help tutorial)\n   clone             Clone a repository into a new directory\n   init              Create an empty Git repository or reinitialize an existing one\n\nwork on the current change (see also: git help everyday)\n   add               Add file contents to the index\n   mv                Move or rename a file, a directory, or a symlink\n   restore           Restore working tree files\n   rm                Remove files from the working tree and from the index\n   sparse-checkout   Initialize and modify the sparse-checkout\n\nexamine the history and state (see also: git help revisions)\n   bisect            Use binary search to find the commit that introduced a bug\n   diff              Show changes between commits, commit and working tree, etc\n   grep              Print lines matching a pattern\n   log               Show commit logs\n   show              Show various types of objects\n   status            Show the working tree status\n\ngrow, mark and tweak your common history\n   branch            List, create, or delete branches\n   commit            Record changes to the repository\n   merge             Join two or more development histories together\n   rebase            Reapply commits on top of another base tip\n   reset             Reset current HEAD to the specified state\n   switch            Switch branches\n   tag               Create, list, delete or verify a tag object signed with GPG\n\ncollaborate (see also: git help workflows)\n   fetch             Download objects and refs from another repository\n   pull              Fetch from and integrate with another repository or a local branch\n   push              Update remote refs along with associated objects\n\n\'git help -a\' and \'git help -g\' list available subcommands and some\nconcept guides. See \'git help <command>\' or \'git help <concept>\'\nto read about a specific subcommand or concept.\nSee \'git help git\' for an overview of the system.\n"
        assert(output == text)
    }
    
    
}
