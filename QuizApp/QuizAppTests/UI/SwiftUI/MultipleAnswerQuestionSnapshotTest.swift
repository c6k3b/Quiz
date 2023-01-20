//  MultipleAnswerQuestionSnapshotTest.swift
//  Created by aa on 1/20/23.

import XCTest
@testable import QuizApp
import SwiftUI

final class MultipleAnswerQuestionSnapshotTest: XCTestCase {
    func test() {
        let sut = MultipleAnswerQuestion(
            title: "A title",
            question: "A question",
            store: .init(
                options: ["Option 1", "Option 2"],
                handler: { _ in }
            )
        )

//        record(
//            snapshot: UIHostingController(rootView: sut).snapshot(for: .iPhone13(style: .light)),
//            named: "two_options"
//        )

        assert(
            snapshot: UIHostingController(rootView: sut).snapshot(for: .iPhone13(style: .light)),
            named: "two_options"
        )
    }
}
