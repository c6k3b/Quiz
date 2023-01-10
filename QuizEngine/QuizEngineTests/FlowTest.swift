import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {
    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSUT(questions: []).start()
        XCTAssertTrue(delegate.routedQuestions.isEmpty)
    }

    func test_start_withQuestion_routeToCorrectQuestion() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertEqual(delegate.routedQuestions, ["Q1"])
    }

    func test_start_withQuestion_routeToCorrectQuestion_2() {
        makeSUT(questions: ["Q2"]).start()
        XCTAssertEqual(delegate.routedQuestions, ["Q2"])
    }

    func test_start_withTwoQuestions_routeToFirstQuestion() {
        makeSUT(questions: ["Q1", "Q2"]).start()
        XCTAssertEqual(delegate.routedQuestions, ["Q1"])
    }

    func test_startTwice_withTwoQuestions_routeToFirstQuestionTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        sut.start()

        XCTAssertEqual(delegate.routedQuestions, ["Q1", "Q1"])
    }

    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_routeToSecondAndThirdQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])

        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")

        XCTAssertEqual(delegate.routedQuestions, ["Q1", "Q2", "Q3"])
    }

    func test_startAndAnswerFirstQuestion_withOneQuestions_doesNotRouteToAnotherQuestion() {
        let sut = makeSUT(questions: ["Q1"])

        sut.start()
        delegate.answerCallback("A1")

        XCTAssertEqual(  delegate.routedQuestions, ["Q1"])
    }

    func test_startWithNoQuestions_routesToResult() {
        makeSUT(questions: []).start()
        XCTAssertEqual(delegate.routedResult!.answers, [:])
    }

    func test_startWithOneQuestion_doesNotRouteToResult() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertNil(delegate.routedResult)
    }

    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotRouteToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        delegate.answerCallback("A1")

        XCTAssertNil(delegate.routedResult)
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_routeToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")

        XCTAssertEqual(delegate.routedResult!.answers, ["Q1": "A1", "Q2": "A2"])
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scores() {
        let sut = makeSUT(questions: ["Q1", "Q2"]) { _ in 10 }

        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")

        XCTAssertEqual(delegate.routedResult!.score, 10)
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scoresWithRightAnswers() {
        var receivedAnswers = [String: String]()
        let sut = makeSUT(questions: ["Q1", "Q2"]) { answers in
            receivedAnswers = answers
            return 20
        }

        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")

        XCTAssertEqual(receivedAnswers, ["Q1": "A1", "Q2": "A2"])
    }

    // MARK: - Helpers
    private let delegate = DelegateSpy()
//    private weak var weakSUT: Flow<DelegateSpy>?
//
//    override func tearDown() {
//        super.tearDown()
//
//        XCTAssertNil(
//    weakSUT,
//    "Memory leak detected. Weak reference to the SUT (Flow<DelegateSpy>) instance is not nil."
//    )
//    }

    private func makeSUT(
        questions: [String],
        scoring: @escaping ([String: String]) -> Int = { _ in 0 }
    ) -> Flow<String, String, DelegateSpy> {
        return Flow(questions: questions, router: delegate, scoring: scoring)
    }

    private class DelegateSpy: Router {
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
