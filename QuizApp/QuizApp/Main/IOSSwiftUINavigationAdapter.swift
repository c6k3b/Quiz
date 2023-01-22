//  IOSSwiftUINavigationAdapter.swift
//  Created by aa on 1/19/23.

import SwiftUI
import QuizEngine

final class IOSSwiftUINavigationAdapter: QuizDelegate, QuizDataSource {
    typealias Question = QuizEngine.Question<String>
    typealias Answer = [String]
    typealias Answers = [(question: Question, answer: Answer)]

    private let show: (UIViewController) -> Void
    private let options: [Question: Answer]
    private let correctAnswers: Answers
    private let playAgain: () -> Void
    private var questions: [Question] { correctAnswers.map { $0.question } }

    init(
        show: @escaping (UIViewController) -> Void,
        options: [Question: Answer],
        correctAnswers: Answers,
        playAgain: @escaping () -> Void
    ) {
        self.show = show
        self.options = options
        self.correctAnswers = correctAnswers
        self.playAgain = playAgain
    }

    func answer(for question: Question, completion: @escaping (Answer) -> Void) {
        show(questionViewController(for: question, answerCallback: completion))
    }

    func didCompleteQuiz(withAnswers answers: Answers) {
        show(resultsViewController(for: answers))
    }
}

private extension IOSSwiftUINavigationAdapter {
    func questionViewController(
        for question: Question,
        answerCallback: @escaping (Answer) -> Void
    ) -> UIViewController {
        guard let options = options[question] else {
            fatalError("Couldn't find options for \(question)")
        }
        return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }

    func questionViewController(
        for question: Question,
        options: Answer,
        answerCallback: @escaping (Answer) -> Void
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
                playAgain: playAgain
            )
        )
    }
}
