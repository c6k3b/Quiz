//  Created by aa on 11/6/22.

@available(*, deprecated)
public protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer: Equatable

    typealias AnswerCallback = (Answer) -> Void

    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}

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
    let flow = Flow(questions: questions, delegate: QuizDelegateToRouterAdapter(router)) {
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

    func answer(for question: Question, completion: @escaping (Answer) -> Void) {
        router.routeTo(question: question, answerCallback: completion)
    }

    func handle(result: Result<Question, Answer>) {
        router.routeTo(result: result)
    }
}
