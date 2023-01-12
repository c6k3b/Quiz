//  Quiz.swift
//  Created by aa on 1/12/23.

public final class Quiz {
    private let flow: Any

    private init(flow: Any) {
        self.flow = flow
    }

    public static func start<Question, Answer: Equatable, Delegate: QuizDelegate>(
        questions: [Question],
        delegate: Delegate,
        correctAnswers: [Question: Answer]
    ) -> Quiz where Delegate.Question == Question, Delegate.Answer == Answer {
        let flow = Flow(questions: questions, delegate: delegate) {
            scoring($0, correctAnswers: correctAnswers)
        }
        flow.start()
        return Quiz(flow: flow)
    }
}

public func scoring<Question, Answer: Equatable>(
    _ answers: [Question: Answer],
    correctAnswers: [Question: Answer]
) -> Int {
    return answers.reduce(0) { score, tuple in
        return score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
    }
}
