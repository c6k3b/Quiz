// Copyright © 2023 aa. All rights reserved.

import XCTest
import SwiftUI
import BasicQuizDomain
@testable import QuizApp

final class IOSSwiftUINavigationAdapterTest: XCTestCase {
	func test_questionViewController_singleAnswer_createsControllerWithTitle() throws {
		let view = try XCTUnwrap(makeSingleAnswerQuestion())
		let presenter = QuestionPresenter(questions: questions, question: singleAnswerQuestion)
		XCTAssertEqual(view.title, presenter.title)
	}

	func test_questionViewController_singleAnswer_createsControllerWithQuestion() throws {
		let view = try XCTUnwrap(makeSingleAnswerQuestion())
		XCTAssertEqual(view.question, "Q1")
	}

	func test_questionViewController_singleAnswer_createsControllerWithOptions() throws {
		let view = try XCTUnwrap(makeSingleAnswerQuestion())
		XCTAssertEqual(view.options, options[singleAnswerQuestion])
	}

	func test_questionViewController_singleAnswer_createsControllerWithAnswerCallback() throws {
		var answers = [[String]]()
		let view = try XCTUnwrap(makeSingleAnswerQuestion(answerCallback: { answers.append($0) }))

		XCTAssertEqual(answers, [])

		view.selection(view.options[0])
		XCTAssertEqual(answers, [[view.options[0]]])

		view.selection(view.options[1])
		XCTAssertEqual(answers, [[view.options[0]], [view.options[1]]])
	}

	func test_questionViewController_multipleAnswer_createsControllerWithTitle() throws {
		let view = try XCTUnwrap(makeMultipleAnswerQuestion())
		let presenter = QuestionPresenter(questions: questions, question: multipleAnswerQuestion)
		XCTAssertEqual(view.title, presenter.title)
	}

	func test_questionViewController_multipleAnswer_createsControllerWithQuestion() throws {
		let view = try XCTUnwrap(makeMultipleAnswerQuestion())
		XCTAssertEqual(view.question, "Q2")
	}

	func test_questionViewController_multipleAnswer_createsControllerWithOptions() throws {
		let view = try XCTUnwrap(makeMultipleAnswerQuestion())
		XCTAssertEqual(view.store.options.map(\.text), options[multipleAnswerQuestion])
	}

	func test_resultsViewController_createsControllerWithTitle() throws {
		let (view, presenter) = try XCTUnwrap(makeResults())
		XCTAssertEqual(view.title, presenter.title)
	}

	func test_resultsViewController_createsControllerWithSummary() throws {
		let (view, presenter) = try XCTUnwrap(makeResults())
		XCTAssertEqual(view.summary, presenter.summary)
	}

	func test_resultsViewController_createsControllerWithPresentableAnswers() throws {
		let (view, presenter) = try XCTUnwrap(makeResults())
		XCTAssertEqual(view.answers, presenter.presentableAnswers)
	}

	func test_resultsViewController_createsControllerWithPlayAgainAction() throws {
		var playAgainCount = 0
		let (view, _) = try XCTUnwrap(makeResults(playAgain: { playAgainCount += 1 }))
		XCTAssertEqual(playAgainCount, 0)

		view.playAgain()
		XCTAssertEqual(playAgainCount, 1)

		view.playAgain()
		XCTAssertEqual(playAgainCount, 2)
	}

	func test_answerForQuestion_replacesCurrentView() {
		let (sut, navigation) = makeSUT()

		sut.answer(for: singleAnswerQuestion) { _ in }
		XCTAssertNotNil(navigation.singleCurrentView)

		sut.answer(for: multipleAnswerQuestion) { _ in }
		XCTAssertNotNil(navigation.multipleCurrentView)
	}

	func test_didCompleteQuiz_replacesCurrentView() {
		let (sut, navigation) = makeSUT()

		sut.didCompleteQuiz(withAnswers: correctAnswers)
		XCTAssertNotNil(navigation.resultCurrentView)

		sut.didCompleteQuiz(withAnswers: correctAnswers)
		XCTAssertNotNil(navigation.resultCurrentView)
	}
	
	func test_publishesNavigationChanges() {
		let (sut, navigation) = makeSUT()
		var navigationChangeCount = 0
		let cancelable = navigation.objectWillChange.sink { navigationChangeCount += 1 }
		
		XCTAssertEqual(navigationChangeCount, 0)
		
		sut.answer(for: singleAnswerQuestion) { _ in }
		XCTAssertEqual(navigationChangeCount, 1)
		
		sut.answer(for: multipleAnswerQuestion) { _ in }
		XCTAssertEqual(navigationChangeCount, 2)
		
		sut.didCompleteQuiz(withAnswers: correctAnswers)
		XCTAssertEqual(navigationChangeCount, 3)
		
		cancelable.cancel()
	}

	// MARK: - Helpers
	private var singleAnswerQuestion: Question<String> { .singleAnswer("Q1") }
	private var multipleAnswerQuestion: Question<String> { .multipleAnswer("Q2") }
	private var questions: [Question<String>] {
		[singleAnswerQuestion, multipleAnswerQuestion]
	}
	private var options: [Question<String>: [String]] {
		[singleAnswerQuestion: ["A1", "A2", "A3"], multipleAnswerQuestion: ["A4", "A5", "A6"]]
	}
	private var correctAnswers: [(Question<String>, [String])] {
		[(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A4", "A5"])]
	}

	private func makeSUT(playAgain: @escaping () -> Void = {}) -> (IOSSwiftUINavigationAdapter, QuizNavigationStore) {
		let navigation = QuizNavigationStore()
		let sut = IOSSwiftUINavigationAdapter(
			navigation: navigation,
			options: options,
			correctAnswers: correctAnswers,
			playAgain: playAgain
		)
		return (sut, navigation)
	}

	private func makeSingleAnswerQuestion(answerCallback: @escaping ([String]) -> Void = { _ in }) -> SingleAnswerQuestion? {
		let (sut, navigation) = makeSUT()
		sut.answer(for: singleAnswerQuestion, completion: answerCallback)
		return navigation.singleCurrentView
	}

	private func makeMultipleAnswerQuestion(
		answerCallback: @escaping ([String]) -> Void = { _ in }
	) -> MultipleAnswerQuestion? {
		let (sut, navigation) = makeSUT()
		sut.answer(for: multipleAnswerQuestion, completion: answerCallback)
		return navigation.multipleCurrentView
	}

	private func makeResults(playAgain: @escaping () -> Void = {}) -> (view: ResultView, presenter: ResultsPresenter)? {
		let (sut, navigation) = makeSUT(playAgain: playAgain)
		sut.didCompleteQuiz(withAnswers: correctAnswers)

		let view = navigation.resultCurrentView
		let presenter = ResultsPresenter(
			userAnswers: correctAnswers,
			correctAnswers: correctAnswers,
			scorer: BasicScore.score
		)

		return view.map { ($0, presenter) }
	}
}

private extension QuizNavigationStore {
	var singleCurrentView: SingleAnswerQuestion? {
		if case let .single(view) = currentView { return view }
		return nil
	}
	
	var multipleCurrentView: MultipleAnswerQuestion? {
		if case let .multiple(view) = currentView { return view }
		return nil
	}
	
	var resultCurrentView: ResultView? {
		if case let .result(view) = currentView { return view }
		return nil
	}
}
