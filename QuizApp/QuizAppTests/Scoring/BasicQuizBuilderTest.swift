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
}

struct BasicQuizBuilder {
	private let questions: [Question<String>]
	private let options: [Question<String> : [String]]
	
	init(singleAnswerQuestion: String, options: NonEmptyOptions) {
		let question = Question.singleAnswer(singleAnswerQuestion)
		let answers = [options.head] + options.tail
		
		self.questions = [question]
		self.options = [question: answers]
	}
	
	func build() -> BasicQuiz {
		BasicQuiz(questions: questions, options: options)
	}
}

class BasicQuizBuilderTest: XCTestCase {
	func test_initWithSingleAnswerQuestion() {
		let sut = BasicQuizBuilder(singleAnswerQuestion: "Q1", options: NonEmptyOptions(head: "A1", tail: ["A2", "A3"]))
		
		let result = sut.build()
		
		XCTAssertEqual(result.questions, [.singleAnswer("Q1")])
		XCTAssertEqual(result.options, [.singleAnswer("Q1"): ["A1", "A2", "A3"]])
	}
}
