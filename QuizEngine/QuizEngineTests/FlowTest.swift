import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {
    private let router = RouterSpy()

    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSUT(questions: []).start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }

    func test_start_withQuestion_routeToCorrectQuestion() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_start_withQuestion_routeToCorrectQuestion_2() {
        makeSUT(questions: ["Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }

    func test_start_withTwoQuestions_routeToFirstQuestion() {
        makeSUT(questions: ["Q1", "Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_startTwice_withTwoQuestions_routeToFirstQuestionTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }

    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_routeToSecondAndThirdQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])

        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }

    func test_startAndAnswerFirstQuestion_withOneQuestions_doesNotRouteToAnotherQuestion() {
        let sut = makeSUT(questions: ["Q1"])

        sut.start()
        router.answerCallback("A1")

        XCTAssertEqual(  router.routedQuestions, ["Q1"])
    }

    func test_startWithNoQuestions_routesToResult() {
        makeSUT(questions: []).start()
        XCTAssertEqual(router.routedResult!.answers, [:])
    }

    func test_startWithOneQuestion_doesNotRouteToResult() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertNil(router.routedResult)
    }

    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotRouteToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        router.answerCallback("A1")

        XCTAssertNil(router.routedResult)
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_routeToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(router.routedResult!.answers, ["Q1": "A1", "Q2": "A2"])
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scores() {
        let sut = makeSUT(questions: ["Q1", "Q2"]) { _ in 10 }

        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(router.routedResult!.score, 10)
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scoresWithRightAnswers() {
        var receivedAnswers = [String: String]()
        let sut = makeSUT(questions: ["Q1", "Q2"]) { answers in
            receivedAnswers = answers
            return 20
        }

        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(receivedAnswers, ["Q1": "A1", "Q2": "A2"])
    }

    // MARK: - Helpers
    private func makeSUT(
        questions: [String],
        scoring: @escaping ([String: String]) -> Int = { _ in 0 }
    ) -> Flow<String, String, RouterSpy> {
        return Flow(questions: questions, router: router, scoring: scoring)
    }

    private class RouterSpy: Router {
        var routedQuestions: [String] = []
        var routedResult: Result<String, String>?
        var answerCallback: (String) -> Void = { _ in }

        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }

        func routeTo(result: Result<String, String>) {
            routedResult = result
        }
    }
}
