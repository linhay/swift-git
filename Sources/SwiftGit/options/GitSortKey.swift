//
//  File.swift
//  
//
//  Created by linhey on 2022/7/20.
//

import Foundation

public enum GitSortKey: String {
    // * if HEAD matches ref or space otherwise
    case HEAD
    // the author header-field
    case author
    // the date component of the author header-field
    case authordate
    // the email component of the author header-field
    case authoremail
    // the name component of the author header-field
    case authorname
    // the body of the message
    case body
    // the committer header-field
    case committer
    // the date component of the committer header-field
    case committerdate
    // the email component of the committer header-field
    case committeremail
    // the name component of the committer header-field
    case committername
    // complete message
    case contents
    // the creator header-field
    case creator
    // the date component of the creator header-field
    case creatordate
    // object name of the delta base of the object
    case deltabase
    // number of parent objects
    case numparent
    // the object header-field
    case object
    // object name (SHA-1)
    case objectname
    // the size of the object
    case objectsize
    // the type of the object
    case objecttype
    // the parent header-field
    case parent
    // name of a local ref which represents the @{push} location for the displayed ref
    case push
    // name of the ref
    case refname
    // the subject of the message
    case subject
    // the ref which the given symbolic ref refers to
    case symref
    // the tag header-field
    case tag
    // the tagger header-field
    case tagger
    // the date component of the tagger header-field
    case taggerdate
    // the email component of the tagger header-field
    case taggeremail
    // the name component of the tagger header-field
    case taggername
    // structured information in commit messages
    case trailers
    // the tree header-field
    case tree
    // the type header-field
    case type
    // name of a local ref which can be considered “upstream” from the displayed ref
    case upstream
    // sort by versions
    case version_refname = "version:refname"
}
