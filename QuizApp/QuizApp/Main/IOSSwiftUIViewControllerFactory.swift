//  IOSSwiftUIViewControllerFactory.swift
//  Created by aa on 1/19/23.

import SwiftUI
import QuizEngine

final class IOSSwiftUIViewControllerFactory: ViewControllerFactory {
    typealias Answers = [(question: Question<String>, answer: [String])]

    private let options: [Question<String>: [String]]
    private let correctAnswers: Answers

    private var questions: [Question<String>] { correctAnswers.map { $0.question } }

    init(options: [Question<String>: [String]], correctAnswers: Answers) {
        self.options = options
        self.correctAnswers = correctAnswers
    }

    func questionViewController(
        for question: Question<String>,
        answerCallback: @escaping ([String]) -> Void
    ) -> UIViewController {
        guard let options = options[question] else {
            fatalError("Couldn't find options for \(question)")
        }
        return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }

    private func questionViewController(
        for question: Question<String>,
        options: [String],
        answerCallback: @escaping ([String]) -> Void
    ) -> UIViewController {
        let presenter = QuestionPresenter(questions: questions, question: question)

        switch question {
        case .singleAnswer(let value):
            return UIHostingController(
                rootView: SingleAnswerQuestion(
                    title: presenter.title,
                    question: value,
                    options: options,
                    selection: { answerCallback([$0]) }
                )
            )
        case .multipleAnswer(let value):
            return UIHostingController(
                rootView: MultipleAnswerQuestion(
                    title: presenter.title,
                    question: value,
                    store: .init(options: options, handler: answerCallback)
                )
            )
        }
    }

    func resultsViewController(for userAnswers: Answers) -> UIViewController {
        let presenter = ResultsPresenter(
            userAnswers: userAnswers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score
        )

        return UIHostingController(
            rootView: ResultView(
                title: presenter.title,
                summary: presenter.summary,
                answers: presenter.presentableAnswers,
                playAgain: {}
            )
        )
    }
}
