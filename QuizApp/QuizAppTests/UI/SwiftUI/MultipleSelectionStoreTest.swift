//  MultipleSelectionStoreTest.swift
//  Created by aa on 1/19/23.

import XCTest

struct MultipleSelectionStore {
    var options: [MultipleSelectionOption]
    var canSubmit: Bool { !options.filter(\.isSelected).isEmpty }
    private let handler: ([String]) -> Void

    internal init(options: [String], handler: @escaping ([String]) -> Void = { _ in }) {
        self.options = options.map { MultipleSelectionOption(text: $0) }
        self.handler = handler
    }

    func submit() {
        guard canSubmit else { return }
        handler(options.filter(\.isSelected).map(\.text))
    }
}

struct MultipleSelectionOption {
    let text: String
    var isSelected = false

    mutating func select() {
        isSelected.toggle()
    }
}

final class MultipleSelectionStoreTest: XCTestCase {
    func test_selectOption_togglesState() {
        var sut = MultipleSelectionStore(options: ["o0", "o1"])
        XCTAssertFalse(sut.options[0].isSelected)

        sut.options[0].select()
        XCTAssertTrue(sut.options[0].isSelected)

        sut.options[0].select()
        XCTAssertFalse(sut.options[0].isSelected)
    }

    func test_canSubmit_whenAtLeastOneOptionIsSelected() {
        var sut = MultipleSelectionStore(options: ["o0", "o1"])
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
        var sut = MultipleSelectionStore(options: ["o0", "o1"]) {
            submittedOptions.append($0)
        }

        sut.submit()
        XCTAssertEqual(submittedOptions, [])

        sut.options[0].select()
        sut.submit()
        XCTAssertEqual(submittedOptions, [["o0"]])

        sut.options[1].select()
        sut.submit()
        XCTAssertEqual(submittedOptions, [["o0"], ["o0", "o1"]])
    }
}
