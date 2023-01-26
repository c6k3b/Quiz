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
	private let questions: [Question<String>]
	private let options: [Question<String> : [String]]
	private let correctAnswers: [(Question<String>, [String])]
	
	enum AddingError: Equatable, Error {
		case duplicatedOptions([String])
		case missingAnswerInOptions(answer: [String], options: [String])
	}
	
	init(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
		let question = Question.singleAnswer(singleAnswerQuestion)
		let options = options.all
		
		guard options.contains(answer) else {
			throw AddingError.missingAnswerInOptions(answer: [answer], options: options)
		}
		
		guard Set(options).count == options.count else {
			throw AddingError.duplicatedOptions(options )
		}
		
		self.questions = [question]
		self.options = [question: options]
		self.correctAnswers = [(question, [answer])]
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
		XCTAssertThrowsError(
			try BasicQuizBuilder(
				singleAnswerQuestion: "Q1",
				options: NonEmptyOptions(head: "A1", tail: ["A1", "A3"]),
				answer: "A1"
			)
		) { error in
			XCTAssertEqual(
				error as? BasicQuizBuilder.AddingError,
				BasicQuizBuilder.AddingError.duplicatedOptions(["A1", "A1", "A3"])
			)
		}
	}
	
	func test_initWithSingleAnswerQuestion_missingAnswerInOptions_throw() throws {
		XCTAssertThrowsError(
			try BasicQuizBuilder(
				singleAnswerQuestion: "Q1",
				options: NonEmptyOptions(head: "A1", tail: ["A1", "A3"]),
				answer: "A4"
			)
		) { error in
			XCTAssertEqual(
				error as? BasicQuizBuilder.AddingError,
				BasicQuizBuilder.AddingError.missingAnswerInOptions(
					answer: ["A4"],
					options: ["A1", "A1", "A3"]
				)
			)
		}
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
}
