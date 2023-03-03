// Copyright © 2023 aa. All rights reserved.

import XCTest
import BasicQuizDomain

final class BasicQuizBuilderTest: XCTestCase {	
	// MARK: - Single Answer Question
	func test_initWithSingleAnswerQuestion() throws {
		let sut = try BasicQuizBuilder(
			singleAnswerQuestion: "Q1",
			options: ["A1", "A2", "A3"],
			answer: "A1"
		)
		
		let result = sut.build()
		
		XCTAssertEqual(result.questions, [.singleAnswer("Q1")])
		XCTAssertEqual(result.options, [.singleAnswer("Q1"): ["A1", "A2", "A3"]])
		assertEqual(result.correctAnswers, [(.singleAnswer("Q1"), ["A1"])])
	}
	
	func test_addSingleAnswerQuestion() throws {
		var sut = try BasicQuizBuilder(singleAnswerQuestion: "Q1", options: ["A1", "A2", "A3"], answer: "A1")
		
		try sut.add(singleAnswerQuestion: "Q2", options: ["A4", "A5", "A6"], answer: "A4")
		
		let result = sut.build()
		
		XCTAssertEqual(result.questions, [.singleAnswer("Q1"), .singleAnswer("Q2")])
		XCTAssertEqual(result.options, [
			.singleAnswer("Q1"): ["A1", "A2", "A3"],
			.singleAnswer("Q2"): ["A4", "A5", "A6"]
		])
		assertEqual(result.correctAnswers, [
			(.singleAnswer("Q1"), ["A1"]),
			(.singleAnswer("Q2"), ["A4"])
		])
	}
	
	func test_addingSingleAnswerQuestion() throws {
		let result = try BasicQuizBuilder(singleAnswerQuestion: "Q1", options: ["A1", "A2", "A3"], answer: "A1")
			.adding(singleAnswerQuestion: "Q2", options: ["A4", "A5", "A6"],answer: "A4")
			.build()
		
		XCTAssertEqual(result.questions, [.singleAnswer("Q1"), .singleAnswer("Q2")])
		XCTAssertEqual(result.options, [
			.singleAnswer("Q1"): ["A1", "A2", "A3"],
			.singleAnswer("Q2"): ["A4", "A5", "A6"]
		])
		assertEqual(result.correctAnswers, [
			(.singleAnswer("Q1"), ["A1"]),
			(.singleAnswer("Q2"), ["A4"])
		])
	}
	
	func test_initWithSingleAnswerQuestion_invalidData_throw() throws {
		let params: [(q: String, o: NonEmptyOptions, a: String, e: BasicQuizBuilder.AddingError)] = [
			("Q1", ["A1", "A1", "A3"], "A1", .duplicatedOptions(["A1", "A1", "A3"])),
			("Q1", ["A1", "A2", "A3"], "A4", .missingAnswerInOptions(answer: ["A4"], options: ["A1", "A2", "A3"]))
		]
		
		try params.forEach { q, o, a, e in
			assert(try BasicQuizBuilder(singleAnswerQuestion: q, options: o, answer: a), throws: e)
		}
	}

	func test_addSingleAnswerQuestion_invalidData_throw() throws {
		var sut = try BasicQuizBuilder(
			singleAnswerQuestion: "Q1",
			options: ["A1", "A2", "A3"],
			answer: "A1"
		)
		
		let params: [(q: String, o: NonEmptyOptions, a: String, e: BasicQuizBuilder.AddingError)] = [
			("Q1", ["A4", "A5", "A6"], "A1", .duplicateQuestion(.singleAnswer("Q1"))),
			("Q2", ["A4", "A4", "A6"], "A4", .duplicatedOptions(["A4", "A4", "A6"])),
			("Q2", ["A4", "A5", "A6"], "A7", .missingAnswerInOptions(answer: ["A7"], options: ["A4", "A5", "A6"]))
		]
		
		try params.forEach { q, o, a, e in
			assert(try sut.add(singleAnswerQuestion: q, options: o, answer: a), throws: e)
			assert(try sut.adding(singleAnswerQuestion: q, options: o, answer: a), throws: e)
		}
	}
	
	// MARK: - Multiple Answer Question
	func test_initWithMultipleAnswerQuestion() throws {
		let sut = try BasicQuizBuilder(
			multipleAnswerQuestion: "Q1",
			options: ["A1", "A2", "A3"],
			answer: ["A1", "A2"]
		)
		
		let result = sut.build()
		
		XCTAssertEqual(result.questions, [.multipleAnswer("Q1")])
		XCTAssertEqual(result.options, [.multipleAnswer("Q1"): ["A1", "A2", "A3"]])
		assertEqual(result.correctAnswers, [(.multipleAnswer("Q1"), ["A1", "A2"])])
	}
	
	func test_addMultipleAnswerQuestion() throws {
		var sut = try BasicQuizBuilder(multipleAnswerQuestion: "Q1", options: ["A1", "A2", "A3"], answer: ["A1", "A2"])
		
		try sut.add(multipleAnswerQuestion: "Q2", options: ["A4", "A5", "A6"], answer: ["A4", "A5"])
		
		let result = sut.build()
		
		XCTAssertEqual(result.questions, [.multipleAnswer("Q1"), .multipleAnswer("Q2")])
		XCTAssertEqual(result.options, [
			.multipleAnswer("Q1"): ["A1", "A2", "A3"],
			.multipleAnswer("Q2"): ["A4", "A5", "A6"]
		])
		assertEqual(result.correctAnswers, [
			(.multipleAnswer("Q1"), ["A1", "A2"]),
			(.multipleAnswer("Q2"), ["A4", "A5"])
		])
	}
	
	func test_addingMultipleAnswerQuestion() throws {
		let result = try BasicQuizBuilder(multipleAnswerQuestion: "Q1", options: ["A1", "A2", "A3"], answer: ["A1", "A2"])
			.adding(multipleAnswerQuestion: "Q2", options: ["A4", "A5", "A6"],answer: ["A4", "A5"])
			.build()
		
		XCTAssertEqual(result.questions, [.multipleAnswer("Q1"), .multipleAnswer("Q2")])
		XCTAssertEqual(result.options, [
			.multipleAnswer("Q1"): ["A1", "A2", "A3"],
			.multipleAnswer("Q2"): ["A4", "A5", "A6"]
		])
		assertEqual(result.correctAnswers, [
			(.multipleAnswer("Q1"), ["A1", "A2"]),
			(.multipleAnswer("Q2"), ["A4", "A5"])
		])
	}
	
	func test_initWithMultipleAnswerQuestion_invalidData_throw() throws {
		let params: [(q: String, o: NonEmptyOptions, a: NonEmptyOptions, e: BasicQuizBuilder.AddingError)] = [
			("Q1", ["A1", "A1", "A3"], ["A1", "A3"], .duplicatedOptions(["A1", "A1", "A3"])),
			("Q1", ["A1", "A2", "A3"], ["A1", "A1", "A3"], .duplicatedAnswers(["A1", "A1", "A3"])),
			("Q1", ["A1", "A2", "A3"], ["A4"], .missingAnswerInOptions(answer: ["A4"], options: ["A1", "A2", "A3"]))
		]
		
		try params.forEach { q, o, a, e in
			assert(try BasicQuizBuilder(multipleAnswerQuestion: q, options: o, answer: a), throws: e)
		}
	}
	
	func test_addMultipleAnswerQuestion_invalidData_throw() throws {
		var sut = try BasicQuizBuilder(
			multipleAnswerQuestion: "Q1",
			options: ["A1", "A2", "A3"],
			answer: ["A1", "A2"]
		)
		
		let params: [(q: String, o: NonEmptyOptions, a: NonEmptyOptions, e: BasicQuizBuilder.AddingError)] = [
			("Q1", ["A4", "A5", "A6"], ["A1", "A2"], .duplicateQuestion(.multipleAnswer("Q1"))),
			("Q2", ["A4", "A4", "A6"], ["A4", "A6"], .duplicatedOptions(["A4", "A4", "A6"])),
			("Q2", ["A4", "A5", "A6"], ["A4", "A4", "A6"], .duplicatedAnswers(["A4", "A4", "A6"])),
			("Q2", ["A4", "A5", "A6"], ["A7"], .missingAnswerInOptions(answer: ["A7"], options: ["A4", "A5", "A6"]))
		]
		
		try params.forEach { q, o, a, e in
			assert(try sut.add(multipleAnswerQuestion: q, options: o, answer: a), throws: e)
			assert(try sut.adding(multipleAnswerQuestion: q, options: o, answer: a), throws: e)
		}
	}
	
	
	// MARK: - Helpers
	private func assertEqual(_ argument1: [(Question<String>, [String])], _ argument2: [(Question<String>, [String])], file: StaticString = #filePath, line: UInt = #line) {
		XCTAssertTrue(argument1.elementsEqual(argument2, by: ==), "\(argument1) is not equal to \(argument2)", file: file, line: line)
	}
	
	private func assert<T>(_ expression: @autoclosure () throws -> T, throws expectedError: BasicQuizBuilder.AddingError, file: StaticString = #filePath, line: UInt = #line) {
		XCTAssertThrowsError(try expression()) { error in
			XCTAssertEqual(error as? BasicQuizBuilder.AddingError, expectedError, file: file, line: line)
		}
	}
}
