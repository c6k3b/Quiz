//  MultipleSelectionStoreTest.swift
//  Created by aa on 1/19/23.

import XCTest
@testable import QuizApp

final class MultipleSelectionStoreTest: XCTestCase {
    func test_selectOption_togglesState() {
        var sut = makeSUT()
        XCTAssertFalse(sut.options[0].isSelected)

        sut.options[0].select()
        XCTAssertTrue(sut.options[0].isSelected)

        sut.options[0].select()
        XCTAssertFalse(sut.options[0].isSelected)
    }

    func test_canSubmit_whenAtLeastOneOptionIsSelected() {
        var sut = makeSUT()
        XCTAssertFalse(sut.canSubmit)

        sut.options[0].select()
        XCTAssertTrue(sut.canSubmit)

        sut.options[0].select()
        XCTAssertFalse(sut.canSubmit)

        sut.options[1].select()
        XCTAssertTrue(sut.canSubmit)
    }

    func test_notifiesHandlerWithSelectedOptions() {
        var submittedOptions = [[String]]()
        var sut = makeSUT { submittedOptions.append($0) }

        sut.submit()
        XCTAssertEqual(submittedOptions, [])

        sut.options[0].select()
        sut.submit()
        XCTAssertEqual(submittedOptions, [["o0"]])

        sut.options[1].select()
        sut.submit()
        XCTAssertEqual(submittedOptions, [["o0"], ["o0", "o1"]])
    }

    // MARK: - Helpers
    private func makeSUT(
        _ options: [String] = ["o0", "o1"],
        handler: @escaping ([String]) -> Void = { _ in }
    ) -> MultipleSelectionStore {
        .init(options: options, handler: handler)
    }
}
