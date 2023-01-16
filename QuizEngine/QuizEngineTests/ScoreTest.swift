//  ScoreTest.swift
//  Created by aa on 1/16/23.

import XCTest

class ScoreTest: XCTestCase {
    func test_noAnswers_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: [], comparingTo: []), 0)
    }

    func test_oneWrongAnswer_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: ["wrong"], comparingTo: ["correct"]), 0)
    }

    private class BasicScore {
        static func score(for: [Any], comparingTo: [Any]) -> Int {
            return 0
        }
    }
}
