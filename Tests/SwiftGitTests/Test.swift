//
//  Test.swift
//  SwiftGit
//
//  Created by linhey on 11/26/25.
//

import Testing
import SwiftGit

struct Test {

    @Test func test_format_date() async throws {
        var record = Repository.UserRecord()
        record.set(date: "Mon Nov 17 18:21:25 2025 +0800")
        print(record.date)
    }

}
