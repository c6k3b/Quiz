//  QuestionPresenterTest.swift
//  Created by aa on 11/10/22.

import XCTest
import QuizEngine
@testable import QuizApp

final class QuestionPresenterTest: XCTestCase {
    func test_title_forFirstQuestion_formatTitleForIndex() {
        let sut = QuestionPresenter(questions: [question1, question2], question: question1)

        XCTAssertEqual(sut.title, "Question #1")
    }

    func test_title_forSecondQuestion_formatTitleForIndex() {
        let sut = QuestionPresenter(questions: [question1, question2], question: question2)

        XCTAssertEqual(sut.title, "Question #2")
    }

    func test_title_forUnexistentQuestion_isEmpty() {
        let sut = QuestionPresenter(questions: [], question: Question.singleAnswer("A1"))

        XCTAssertEqual(sut.title, "")
    }

    // MARK: - Helpers
    private let question1 = Question.singleAnswer("A1")
    private let question2 = Question.multipleAnswer("A2")
}
