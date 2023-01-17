//  Created by aa on 11/8/22.

import XCTest
import UIKit
import QuizEngine
@testable import QuizApp

final class IOSViewControllerFactoryTest: XCTestCase {
    func test_questionViewController_singleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(
            questions: [singleAnswerQuestion, multipleAnswerQuestion],
            question: singleAnswerQuestion
        )
        XCTAssertEqual(makeQuestionsController(question: singleAnswerQuestion).title, presenter.title)
    }

    func test_questionViewController_singleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionsController(question: singleAnswerQuestion).question, "Q1")
    }

    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionsController(question: singleAnswerQuestion).options, options)
    }

    func test_questionViewController_singleAnswer_createsControllerWithSingleSelection() {
        XCTAssertFalse(makeQuestionsController(question: singleAnswerQuestion).allowsMultipleSelection)
    }

    func test_questionViewController_multipleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(
            questions: [singleAnswerQuestion, multipleAnswerQuestion],
            question: multipleAnswerQuestion
        )
        XCTAssertEqual(makeQuestionsController(question: multipleAnswerQuestion).title, presenter.title)
    }

    func test_questionViewController_multipleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionsController(question: multipleAnswerQuestion).question, "Q1")
    }

    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionsController(question: multipleAnswerQuestion).options, options)
    }

    func test_questionViewController_multipleAnswer_createsControllerWithSingleSelection() {
        XCTAssertTrue(makeQuestionsController(question: multipleAnswerQuestion).allowsMultipleSelection)
    }

    func test_resultsViewController_createsControllerWithTitle() {
        let results = makeResults()

        XCTAssertEqual(results.controller.title, results.presenter.title)
    }

    func test_resultsViewController_createsControllerWithSummary() {
        let results = makeResults()

        XCTAssertEqual(results.controller.summary, results.presenter.summary)
    }

    func test_resultsViewController_createsControllerWithPresentableAnswers() {
        let results = makeResults()
        XCTAssertEqual(results.controller.answers.count, results.presenter.presentableAnswers.count)
    }

    // MARK: - Helpers
    private let singleAnswerQuestion = Question.singleAnswer("Q1")
    private let multipleAnswerQuestion = Question.multipleAnswer("Q1")
    private let options = ["A1", "A2"]

    private func makeSUT(
        options: [Question<String>: [String]] = [:],
        correctAnswers: [(Question<String>, [String])] = []
    ) -> IOSViewControllerFactory {
        .init(options: options, correctAnswers: correctAnswers)
    }

    private func makeQuestionsController(
        question: Question<String> = Question.singleAnswer("")
    ) -> QuestionViewController {
        let sut = makeSUT(
            options: [question: options],
            correctAnswers: [(singleAnswerQuestion, []), (multipleAnswerQuestion, [])]
        )
        return (sut.questionViewController(for: question, answerCallback: { _ in }) as? QuestionViewController)!
    }

    private func makeResults() -> (controller: ResultsViewController, presenter: ResultsPresenter) {
        let userAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A1", "A2"])]
        let correctAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A1", "A2"])]

        let sut = makeSUT(correctAnswers: correctAnswers)
        let presenter = ResultsPresenter(
            userAnswers: userAnswers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score
        )
        let controller = sut.resultsViewController(for: userAnswers) as? ResultsViewController

        return (controller!, presenter)
    }
}
