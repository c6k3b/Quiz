//  Assertions.swift
//  Created by aa on 1/16/23.

import XCTest

func assertEqual(
    _ argument1: [(String, String)],
    _ argument2: [(String, String)],
    file: StaticString = #filePath,
    line: UInt = #line
) {
    XCTAssertTrue(
        argument1.elementsEqual(argument2, by: ==),
        "\(argument1) is not equal to \(argument2)",
        file: file,
        line: line
    )
}
