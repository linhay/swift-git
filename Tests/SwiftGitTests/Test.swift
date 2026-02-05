//
//  Test.swift
//  SwiftGit
//
//  Created by linhey on 11/26/25.
//

import Foundation

import Testing

import SwiftGit

struct Test {

    @Test func test_format_date() async throws {
        var record = Repository.UserRecord()
        record.set(date: "Mon Nov 17 18:21:25 2025 +0800")
        var components = DateComponents()
        components.year = 2025
        components.month = 11
        components.day = 17
        components.hour = 18
        components.minute = 21
        components.second = 25
        components.timeZone = TimeZone(secondsFromGMT: 8 * 3600)
        let calendar = Calendar(identifier: .gregorian)
        let expected = calendar.date(from: components)
        #expect(record.date == expected)
    }

}
