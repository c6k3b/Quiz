// Copyright © 2023 aa. All rights reserved.

import XCTest
import QuizEngine

struct BasicQuiz {
	let questions: [Question<String>]
	let options: [Question<String> : [String]]
	let correctAnswers: [(Question<String>, [String])]
}

struct NonEmptyOptions {
	let head: String
	let tail: [String]
	
	init(_ head: String, _ tail: [String]) {
		self.head = head
		self.tail = tail
	}
	
	var all: [String] { [head] + tail }
}

struct BasicQuizBuilder {
	private var questions: [Question<String>] = []
	private var options: [Question<String> : [String]] = [:]
	private var correctAnswers: [(Question<String>, [String])] = []
	
	enum AddingError: Equatable, Error {
		case duplicateQuestion(Question<String>)
		case duplicatedOptions([String])
		case duplicatedAnswers([String])
		case missingAnswerInOptions(answer: [String], options: [String])
	}
	
	private init(questions: [Question<String>], options: [Question<String> : [String]], correctAnswers: [(Question<String>, [String])]) {
		self.questions = questions
		self.options = options
		self.correctAnswers = correctAnswers
	}
	
	init(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
		try add(singleAnswerQuestion: singleAnswerQuestion, options: options, answer: answer)
	}
	
	mutating func add(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
		self = try adding(singleAnswerQuestion: singleAnswerQuestion, options: options, answer: answer)
	}
	
	func adding(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws -> BasicQuizBuilder {
		try adding(
			question: Question.singleAnswer(singleAnswerQuestion),
			options: options.all,
			answer: [answer]
		)
	}
	
	func build() -> BasicQuiz {
		BasicQuiz(questions: questions, options: options, correctAnswers: correctAnswers)
	}

	private func adding(question: Question<String>, options: [String], answer: [String]) throws -> BasicQuizBuilder {
		guard !questions.contains(question) else {
			throw AddingError.duplicateQuestion(question)
		}
		
		guard Set(options).count == options.count else {
			throw AddingError.duplicatedOptions(options)
		}
		
		guard Set(answer).count == answer.count else {
			throw AddingError.duplicatedAnswers(answer)
		}
		
		guard Set(answer).isSubset(of: Set(options)) else {
			throw AddingError.missingAnswerInOptions(answer: answer, options: options)
		}
		
		var newOptions = self.options
		newOptions[question] = options
		
		return .init(
			questions: questions + [question],
			options: newOptions,
			correctAnswers: correctAnswers + [(question, answer)]
		)
	}
}

class BasicQuizBuilderTest: XCTestCase {
	
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
	
	
	
	// MARK: - Helpers
	private func assertEqual(_ argument1: [(Question<String>, [String])], _ argument2: [(Question<String>, [String])], file: StaticString = #filePath, line: UInt = #line) {
		XCTAssertTrue(argument1.elementsEqual(argument2, by: ==), "\(argument1) is not equal to \(argument2)", file: file, line: line)
	}
	
	func assert<T>(_ expression: @autoclosure () throws -> T, throws expectedError: BasicQuizBuilder.AddingError, file: StaticString = #filePath, line: UInt = #line) {
		XCTAssertThrowsError(try expression()) { error in
			XCTAssertEqual(error as? BasicQuizBuilder.AddingError, expectedError, file: file, line: line)
		}
	}
}

extension NonEmptyOptions: ExpressibleByArrayLiteral {
	init(arrayLiteral elements: String...) {
		self.init(elements[0], Array(elements.dropFirst()))
	}
}
