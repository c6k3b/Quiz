// Copyright © 2023 aa. All rights reserved.

import XCTest
import QuizEngine

struct BasicQuiz {
	let questions: [Question<String>]
	let options: [Question<String> : [String]]
}

struct NonEmptyOptions {
	let head: String
	let tail: [String]
	
	var all: [String] { [head] + tail }
}

struct BasicQuizBuilder {
	private let questions: [Question<String>]
	private let options: [Question<String> : [String]]
	
	enum AddingError: Equatable, Error {
		case duplicatedOptions([String])
	}
	
	init(singleAnswerQuestion: String, options: NonEmptyOptions) throws {
		let question = Question.singleAnswer(singleAnswerQuestion)
		let options = options.all
		
		guard Set(options).count == options.count else {
			throw AddingError.duplicatedOptions(options )
		}
		
		self.questions = [question]
		self.options = [question: options]
	}
	
	func build() -> BasicQuiz {
		BasicQuiz(questions: questions, options: options)
	}
}

class BasicQuizBuilderTest: XCTestCase {
	func test_initWithSingleAnswerQuestion() throws {
		let sut = try BasicQuizBuilder(
			singleAnswerQuestion: "Q1",
			options: NonEmptyOptions(head: "A1", tail: ["A2", "A3"])
		)
		
		let result = sut.build()
		
		XCTAssertEqual(result.questions, [.singleAnswer("Q1")])
		XCTAssertEqual(result.options, [.singleAnswer("Q1"): ["A1", "A2", "A3"]])
	}
	
	func test_initWithSingleAnswerQuestion_duplicateOptions_throw() throws {
		XCTAssertThrowsError(
			try BasicQuizBuilder(
				singleAnswerQuestion: "Q1",
				options: NonEmptyOptions(head: "A1", tail: ["A1", "A3"])
			)
		) { error in
			XCTAssertEqual(
				error as? BasicQuizBuilder.AddingError,
				BasicQuizBuilder.AddingError.duplicatedOptions(["A1", "A1", "A3"])
			)
		}
	}
}
