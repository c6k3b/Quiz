// Copyright © 2023 aa. All rights reserved.

import XCTest
import QuizEngine

struct BasicQuiz {
	let questions: [Question<String>]
}

struct BasicQuizBuilder {
	private let questions: [Question<String>]
	
	init(singleAnswerQuestion: String) {
		questions = [.singleAnswer(singleAnswerQuestion)]
	}
	
	func build() -> BasicQuiz {
		BasicQuiz(questions: questions)
	}
}

class BasicQuizBuilderTest: XCTestCase {
	func test_initWithSingleAnswerQuestion() {
		let sut = BasicQuizBuilder(singleAnswerQuestion: "Q1")
		
		XCTAssertEqual(sut.build().questions, [.singleAnswer("Q1")])
	}
}