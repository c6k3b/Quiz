// Copyright © 2023 aa. All rights reserved.

import XCTest
@testable import QuizApp

final class MultipleSelectionStoreTest: XCTestCase {
	func test_selectOption_togglesState() {
		var sut = makeSUT()
		XCTAssertFalse(sut.options[0].isSelected)

		sut.options[0].toggleSelection()
		XCTAssertTrue(sut.options[0].isSelected)

		sut.options[0].toggleSelection()
		XCTAssertFalse(sut.options[0].isSelected)
	}

	func test_canSubmit_whenAtLeastOneOptionIsSelected() {
		var sut = makeSUT()
		XCTAssertFalse(sut.canSubmit)

		sut.options[0].toggleSelection()
		XCTAssertTrue(sut.canSubmit)

		sut.options[0].toggleSelection()
		XCTAssertFalse(sut.canSubmit)

		sut.options[1].toggleSelection()
		XCTAssertTrue(sut.canSubmit)
	}

	func test_notifiesHandlerWithSelectedOptions() {
		var submittedOptions = [[String]]()
		var sut = makeSUT { submittedOptions.append($0) }

		sut.submit()
		XCTAssertEqual(submittedOptions, [])

		sut.options[0].toggleSelection()
		sut.submit()
		XCTAssertEqual(submittedOptions, [["o0"]])

		sut.options[1].toggleSelection()
		sut.submit()
		XCTAssertEqual(submittedOptions, [["o0"], ["o0", "o1"]])
	}

	// MARK: - Helpers
	private func makeSUT(_ options: [String] = ["o0", "o1"], handler: @escaping ([String]) -> Void = { _ in }) -> MultipleSelectionStore {
		.init(options: options, handler: handler)
	}
}
