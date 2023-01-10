//  Created by aa on 11/6/22.

@available(*, deprecated)
public class Game<Question, Answer, R: Router> {
    let flow: Any

    init(flow: Any) {
        self.flow = flow
    }
}

@available(*, deprecated)
public func startGame<Question, Answer: Equatable, R: Router>(
    questions: [Question],
    router: R,
    correctAnswers: [Question: Answer]
) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
    let flow = Flow(questions: questions, router: QuizDelegateToRouterAdapter(router)) {
        scoring($0, correctAnswers: correctAnswers)
    }
    flow.start()
    return Game(flow: flow)
}

@available(*, deprecated)
private class QuizDelegateToRouterAdapter<R: Router>: QuizDelegate {
    typealias Question = R.Question
    typealias Answer = R.Answer

    private let router: R

    init(_ router: R) {
        self.router = router
    }

    func handle(question: Question, answerCallback: @escaping (Answer) -> Void) {
        router.routeTo(question: question, answerCallback: answerCallback)
    }

    func handle(result: Result<Question, Answer>) {
        router.routeTo(result: result)
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
