import XCTest
@testable import SwiftGit

final class SwiftGitTests: XCTestCase {

    func testExample() throws {
        print(try Git.create(at: "/Users/linhey/Desktop/asset-template").run("log"))
    }
    
    func testClone() throws {
      try Git
            .clone(repo: "git@github.com:linhay/SwiftGit.git", parentFolder: "/Users/linhey/Downloads/", options: [])
    }
    
    func testStatus() throws {
       let result = try Git.create(at: "/Users/linhey/Downloads/SwiftGit")
            .status()
        print(result)
    }

    func testCloneDoc() {
        let doc = """
    -v, --verbose         #be more verbose
    -q, --quiet           #be more quiet
    --progress            #force progress reporting
    --reject-shallow      #don't clone shallow repository
    -n, --no-checkout     #don't create a checkout
    --bare                #create a bare repository
    --mirror              #create a mirror repository (implies bare)
    -l, --local           #to clone from a local repository
    --no-hardlinks        #don't use local hardlinks, always copy
    -s, --shared          #setup as shared repository
    --recurse-submodules[=<pathspec>] #initialize submodules in the clone
    --recursive ...       #alias of --recurse-submodules
    -j, --jobs <n>        #number of submodules cloned in parallel
    --template <template-directory> #directory from which templates will be used
    --reference <repo>    #reference repository
    --reference-if-able <repo> #reference repository
    --dissociate          #use --reference only while cloning
    -o, --origin <name>   #use <name> instead of 'origin' to track upstream
    -b, --branch <branch> #checkout <branch> instead of the remote's HEAD
    -u, --upload-pack <path> #path to git-upload-pack on the remote
    --depth <depth>       #create a shallow clone of that depth
    --shallow-since <time> #create a shallow clone since a specific time
    --shallow-exclude <revision> #deepen history of shallow clone, excluding rev
    --single-branch       #clone only one branch, HEAD or --branch
    --no-tags             #don't clone any tags, and make later fetches not to follow them
    --shallow-submodules  #any cloned submodules will be shallow
    --separate-git-dir <gitdir> #separate git dir from working tree
    -c, --config <key=value> #set config inside the new repository
    --server-option <server-specific> #option to transmit
    -4, --ipv4            #use IPv4 addresses only
    -6, --ipv6            #use IPv6 addresses only
    --filter <args>       #object filtering
    --remote-submodules   #any cloned submodules will use their remote-tracking branch
    --sparse              #initialize sparse-checkout file to include only files at root
"""

        var opts = [String]()
        for line in doc.split(separator: "\n").map(\.description) {
            let list = line.split(separator: "#").map(\.description)
            guard let opt = list.first?.split(separator: ",").last?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let mark = list.last?.description else {
                continue
            }

            if opt.contains(" <") {
                let list2 = opt.split(separator: " ")
                let name = list2.first!
                    .replacingOccurrences(of: "--", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                let args = list2.last?
                    .replacingOccurrences(of: "<", with: "")
                    .replacingOccurrences(of: ">", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                opts.append(#"/// "# + mark)
                opts.append("\n")
                opts.append("static func \(name)"
                            + #"(_ value: String) -> CloneOptions { .init(stringLiteral: "--"#
                            + name
                            + #" \(value)") }"# )
                opts.append("\n")
            } else {
                let name = opt
                    .replacingOccurrences(of: "--", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                opts.append(#"/// "# + mark)
                opts.append("\n")
                opts.append("static let \(name): CloneOptions = \"--\(name)\"")
                opts.append("\n")
            }            
        }
        print(opts.joined())


    }

}
