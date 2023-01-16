import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {
    func test_start_withNoQuestions_doesNotDelegateQuestionHandling() {
        makeSUT(questions: []).start()
        XCTAssertTrue(delegate.questionsAsked.isEmpty)
    }

    func test_start_withQuestion_delegatesCorrectQuestionHandling() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertEqual(delegate.questionsAsked, ["Q1"])
    }

    func test_start_withQuestion_delegatesAnotherCorrectQuestionHandling() {
        makeSUT(questions: ["Q2"]).start()
        XCTAssertEqual(delegate.questionsAsked, ["Q2"])
    }

    func test_start_withTwoQuestions_delegatesFirstQuestionHandling() {
        makeSUT(questions: ["Q1", "Q2"]).start()
        XCTAssertEqual(delegate.questionsAsked, ["Q1"])
    }

    func test_startTwice_withTwoQuestions_delegatesFirstQuestionHandlingTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        sut.start()

        XCTAssertEqual(delegate.questionsAsked, ["Q1", "Q1"])
    }

    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_delegatesSecondAndThirdQuestionHandling() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])

        sut.start()
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")

        XCTAssertEqual(delegate.questionsAsked, ["Q1", "Q2", "Q3"])
    }

    func test_startAndAnswerFirstQuestion_withOneQuestions_doesNotDelegateAnotherQuestionHandling() {
        let sut = makeSUT(questions: ["Q1"])

        sut.start()
        delegate.answerCompletions[0]("A1")

        XCTAssertEqual(  delegate.questionsAsked, ["Q1"])
    }

    func test_startWithOneQuestion_doesNotCompleteQuiz() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }

    func test_startWithNoQuestions_completeWithEmptyQuiz() {
        makeSUT(questions: []).start()
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        XCTAssertTrue(delegate.completedQuizzes[0].isEmpty)
    }

    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotCompleteQuiz() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        delegate.answerCompletions[0]("A1")

        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_completesQuiz() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")

        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
    }

    func test_startAndAnswerFirstAndSecondQuestionTwice_withTwoQuestions_completesQuizTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")

        delegate.answerCompletions[0]("A1-1")
        delegate.answerCompletions[1]("A2-2")

        XCTAssertEqual(delegate.completedQuizzes.count, 2)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
        assertEqual(delegate.completedQuizzes[1], [("Q1", "A1-1"), ("Q2", "A2-2")])
    }

    // MARK: - Helpers
    private let delegate = DelegateSpy()
    private weak var weakSUT: Flow<DelegateSpy>?

    override func tearDown() {
        super.tearDown()
        XCTAssertNil(weakSUT, "Memory leak detected. Weak reference to the SUT instance is not nil.")
    }

    private func makeSUT(questions: [String]) -> Flow<DelegateSpy> {
        let sut = Flow(questions: questions, delegate: delegate)
        weakSUT = sut
        return sut
    }

    private func assertEqual(
        _ argument1: [(String, String)],
        _ argument2: [(String, String)],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertTrue(
            argument1.elementsEqual(argument2, by: ==),
            "\(argument1) is not equal to \(argument2)",
            file: file,
            line: line
        )
    }

    private class DelegateSpy: QuizDelegate {
        var questionsAsked: [String] = []
        var answerCompletions: [(String) -> Void] = []

        var handledResult: Result<String, String>?
        var completedQuizzes = [[(String, String)]]()

        func answer(for question: String, completion: @escaping (String) -> Void) {
            questionsAsked.append(question)
            answerCompletions.append(completion)
        }

        func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
            completedQuizzes.append(answers)
        }

        func handle(result: Result<String, String>) {
            handledResult = result
        }
    }
}
