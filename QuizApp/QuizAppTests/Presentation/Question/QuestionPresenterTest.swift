// Copyright © 2023 aa. All rights reserved.

import XCTest
import BasicQuizDomain
@testable import QuizApp

final class QuestionPresenterTest: XCTestCase {
	private let question1 = Question.singleAnswer("A1")
	private let question2 = Question.multipleAnswer("A2")

	func test_title_forFirstQuestion_formatTitleForIndex() {
		let sut = QuestionPresenter(questions: [question1, question2], question: question1)
		XCTAssertEqual(sut.title, "1 of 2")
	}

	func test_title_forSecondQuestion_formatTitleForIndex() {
		let sut = QuestionPresenter(questions: [question1, question2], question: question2)
		XCTAssertEqual(sut.title, "2 of 2")
	}

	func test_title_forUnexistentQuestion_isEmpty() {
		let sut = QuestionPresenter(questions: [], question: Question.singleAnswer("A1"))
		XCTAssertEqual(sut.title, "")
	}
}
