//  Created by aa on 11/8/22.

import XCTest
import UIKit
import QuizEngine
@testable import QuizApp

class IOSViewControllerFactoryTest: XCTestCase {
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q1")
    let options = ["A1", "A2"]

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
    func makeSUT(
        options: [Question<String>: [String]] = [:],
        correctAnswers: [(Question<String>, [String])] = []
    ) -> IOSViewControllerFactory {
        .init(options: options, correctAnswers: correctAnswers)
    }

    func makeQuestionsController(question: Question<String> = Question.singleAnswer("")) -> QuestionViewController {
        let sut = makeSUT(
            options: [question: options],
            correctAnswers: [(singleAnswerQuestion, []), (multipleAnswerQuestion, [])]
        )

        return (sut.questionViewController(for: question, answerCallback: { _ in }) as? QuestionViewController)!
    }

    func makeResults() -> (controller: ResultsViewController, presenter: ResultsPresenter) {
        let userAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A1", "A2"])]
        let correctAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A1", "A2"])]

        let sut = makeSUT(correctAnswers: correctAnswers)
        let presenter = ResultsPresenter(
            userAnswers: userAnswers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score
        )
        let controller = sut.resultsViewConroller(for: userAnswers) as? ResultsViewController

        return (controller!, presenter)
    }
}

private extension ResultsPresenter {
    convenience init(
        result: Result<Question<String>, [String]>,
        questions: [Question<String>],
        correctAnswers: [Question<String>: [String]]
    ) {
        self.init(
            userAnswers: questions.map { question in
                (question, result.answers[question]!)
            },
            correctAnswers: questions.map { question in
                (question, correctAnswers[question]!)
            },
            scorer: { _, _ in result.score }
        )
    }
}
