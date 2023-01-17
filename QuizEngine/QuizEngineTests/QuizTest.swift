//  QuizTest.swift
//  Created by aa on 1/12/23.

import XCTest
import QuizEngine

final class QuizTest: XCTestCase {
    func test_startQuiz_answerAllQuestions_completeWithAnswers() {
        let delegate = DelegateSpy()
        let dataSource = DataSourceSpy()

        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate, dataSource: dataSource)

        dataSource.answerCompletions[0]("A1")
        dataSource.answerCompletions[1]("A2")

        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
    }

    func test_startQuiz_answerAllQuestionsTwice_completeWithNewAnswers() {
        let delegate = DelegateSpy()
        let dataSource = DataSourceSpy()

        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate, dataSource: dataSource)

        dataSource.answerCompletions[0]("A1")
        dataSource.answerCompletions[1]("A2")

        dataSource.answerCompletions[0]("A1-1")
        dataSource.answerCompletions[1]("A2-2")

        XCTAssertEqual(delegate.completedQuizzes.count, 2)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
        assertEqual(delegate.completedQuizzes[1], [("Q1", "A1-1"), ("Q2", "A2-2")])
    }

    // MARK: - Helpers
    private var quiz: Quiz?
}
