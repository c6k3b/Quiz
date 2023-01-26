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
	
	var all: [String] { [head] + tail }
}

struct BasicQuizBuilder {
	private var questions: [Question<String>] = []
	private var options: [Question<String> : [String]] = [:]
	private var correctAnswers: [(Question<String>, [String])] = []
	
	enum AddingError: Equatable, Error {
		case duplicatedOptions([String])
		case missingAnswerInOptions(answer: [String], options: [String])
		case duplicateQuestion(Question<String>)
	}
	
	init(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
		try add(singleAnswerQuestion: singleAnswerQuestion, options: options, answer: answer)
	}
	
	private init(questions: [Question<String>], options: [Question<String> : [String]], correctAnswers: [(Question<String>, [String])]) {
		self.questions = questions
		self.options = options
		self.correctAnswers = correctAnswers
	}
	
	mutating func add(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
		self = try adding(singleAnswerQuestion: singleAnswerQuestion, options: options, answer: answer)
	}
	
	func adding(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws -> BasicQuizBuilder {
		let question = Question.singleAnswer(singleAnswerQuestion)
		let options = options.all
		
		guard !questions.contains(question) else { throw AddingError.duplicateQuestion(question) }
		guard options.contains(answer) else { throw AddingError.missingAnswerInOptions(answer: [answer], options: options) }
		guard Set(options).count == options.count else { throw AddingError.duplicatedOptions(options) }
		
		var newOptions = self.options
		newOptions[question] = options
		
		return .init(
			questions: questions + [question],
			options: newOptions,
			correctAnswers: correctAnswers + [(question, [answer])]
		)
	}
	
	func build() -> BasicQuiz {
		BasicQuiz(questions: questions, options: options, correctAnswers: correctAnswers)
	}
}

class BasicQuizBuilderTest: XCTestCase {
	func test_initWithSingleAnswerQuestion() throws {
		let sut = try BasicQuizBuilder(
			singleAnswerQuestion: "Q1",
			options: NonEmptyOptions(head: "A1", tail: ["A2", "A3"]),
			answer: "A1"
		)
		
		let result = sut.build()
		
		XCTAssertEqual(result.questions, [.singleAnswer("Q1")])
		XCTAssertEqual(result.options, [.singleAnswer("Q1"): ["A1", "A2", "A3"]])
		assertEqual(result.correctAnswers, [(.singleAnswer("Q1"), ["A1"])])
	}
	
	func test_initWithSingleAnswerQuestion_duplicateOptions_throw() throws {
		assert(
			try BasicQuizBuilder(
				singleAnswerQuestion: "Q1",
				options: NonEmptyOptions(head: "A1", tail: ["A1", "A3"]),
				answer: "A1"
			),
			throws: .duplicatedOptions(["A1", "A1", "A3"])
		)
	}
	
	func test_initWithSingleAnswerQuestion_missingAnswerInOptions_throw() throws {
		assert(
			try BasicQuizBuilder(
				singleAnswerQuestion: "Q1",
				options: NonEmptyOptions(head: "A1", tail: ["A1", "A3"]),
				answer: "A4"
			),
			throws: .missingAnswerInOptions(answer: ["A4"], options: ["A1", "A1", "A3"])
		)
	}
	
	func test_addSingleAnswerQuestion() throws {
		var sut = try BasicQuizBuilder(
			singleAnswerQuestion: "Q1",
			options: NonEmptyOptions(head: "A1", tail: ["A2", "A3"]),
			answer: "A1"
		)
		
		try sut.add(
			singleAnswerQuestion: "Q2",
			options: NonEmptyOptions(head: "A4", tail: ["A5", "A6"]),
			answer: "A4"
		)
		
		let result = sut.build()
		
		XCTAssertEqual(result.questions, [
			.singleAnswer("Q1"),
			.singleAnswer("Q2")
		])
		XCTAssertEqual(result.options, [
			.singleAnswer("Q1"): ["A1", "A2", "A3"],
			.singleAnswer("Q2"): ["A4", "A5", "A6"]
		])
		assertEqual(result.correctAnswers, [
			(.singleAnswer("Q1"), ["A1"]),
			(.singleAnswer("Q2"), ["A4"])
		])
	}
	
	func test_addSingleAnswerQuestion_duplicateOptions_throw() throws {
		var sut = try BasicQuizBuilder(
			singleAnswerQuestion: "Q1",
			options: NonEmptyOptions(head: "A1", tail: ["A2", "A3"]),
			answer: "A1"
		)
		
		assert(
			try sut.add(
				singleAnswerQuestion: "Q2",
				options: NonEmptyOptions(head: "A4", tail: ["A4", "A6"]),
				answer: "A4"
			),
			throws: .duplicatedOptions(["A4", "A4", "A6"])
		)
	}
	
	func test_addSingleAnswerQuestion_missingAnswerInOptions_throw() throws {
		var sut = try BasicQuizBuilder(
			singleAnswerQuestion: "Q1",
			options: NonEmptyOptions(head: "A1", tail: ["A2", "A3"]),
			answer: "A1"
		)
		
		assert(
			try sut.add(
				singleAnswerQuestion: "Q2",
				options: NonEmptyOptions(head: "A4", tail: ["A5", "A6"]),
				answer: "A7"
			),
			throws: .missingAnswerInOptions(answer: ["A7"], options: ["A4", "A5", "A6"])
		)
	}
	
	func test_addSingleAnswerQuestion_duplicateQuestion_throw() throws {
		var sut = try BasicQuizBuilder(
			singleAnswerQuestion: "Q1",
			options: NonEmptyOptions(head: "A1", tail: ["A2", "A3"]),
			answer: "A1"
		)
		
		assert(
			try sut.add(
				singleAnswerQuestion: "Q1",
				options: NonEmptyOptions(head: "A4", tail: ["A5", "A6"]),
				answer: "A4"
			),
			throws: .duplicateQuestion(.singleAnswer("Q1"))
		)
	}
	
	func test_addingSingleAnswerQuestion() throws {
		let sut = try BasicQuizBuilder(
			singleAnswerQuestion: "Q1",
			options: NonEmptyOptions(head: "A1", tail: ["A2", "A3"]),
			answer: "A1"
		).adding(
			singleAnswerQuestion: "Q2",
			options: NonEmptyOptions(head: "A4", tail: ["A5", "A6"]),
			answer: "A4"
		)
		
		let result = sut.build()
		
		XCTAssertEqual(result.questions, [
			.singleAnswer("Q1"),
			.singleAnswer("Q2")
		])
		XCTAssertEqual(result.options, [
			.singleAnswer("Q1"): ["A1", "A2", "A3"],
			.singleAnswer("Q2"): ["A4", "A5", "A6"]
		])
		assertEqual(result.correctAnswers, [
			(.singleAnswer("Q1"), ["A1"]),
			(.singleAnswer("Q2"), ["A4"])
		])
	}
	
	func test_addingSingleAnswerQuestion_duplicateOptions_throw() throws {
		let sut = try BasicQuizBuilder(
			singleAnswerQuestion: "Q1",
			options: NonEmptyOptions(head: "A1", tail: ["A2", "A3"]),
			answer: "A1"
		)
		
		assert(
			try sut.adding(
				singleAnswerQuestion: "Q2",
				options: NonEmptyOptions(head: "A4", tail: ["A4", "A6"]),
				answer: "A4"
			),
			throws: .duplicatedOptions(["A4", "A4", "A6"])
		)
	}
	
	func test_addingSingleAnswerQuestion_missingAnswerInOptions_throw() throws {
		let sut = try BasicQuizBuilder(
			singleAnswerQuestion: "Q1",
			options: NonEmptyOptions(head: "A1", tail: ["A2", "A3"]),
			answer: "A1"
		)
		
		assert(
			try sut.adding(
				singleAnswerQuestion: "Q2",
				options: NonEmptyOptions(head: "A4", tail: ["A5", "A6"]),
				answer: "A7"
			),
			throws: .missingAnswerInOptions(answer: ["A7"], options: ["A4", "A5", "A6"])
		)
	}
	
	func test_addingSingleAnswerQuestion_duplicateQuestion_throw() throws {
		let sut = try BasicQuizBuilder(
			singleAnswerQuestion: "Q1",
			options: NonEmptyOptions(head: "A1", tail: ["A2", "A3"]),
			answer: "A1"
		)
		
		assert(
			try sut.adding(
				singleAnswerQuestion: "Q1",
				options: NonEmptyOptions(head: "A4", tail: ["A5", "A6"]),
				answer: "A4"
			),
			throws: .duplicateQuestion(.singleAnswer("Q1"))
		)
	}
	
	// MARK: - Helpers
	private func assertEqual(
		_ argument1: [(Question<String>, [String])],
		_ argument2: [(Question<String>, [String])],
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
	
	func assert<T>(
		_ expression: @autoclosure () throws -> T,
		throws expectedError: BasicQuizBuilder.AddingError,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		XCTAssertThrowsError(try expression()) { error in
			XCTAssertEqual(
				error as? BasicQuizBuilder.AddingError,
				expectedError,
				file: file,
				line: line
			)
		}
	}
}
