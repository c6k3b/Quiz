//  Created by aa on 11/6/22.

@available(*, deprecated, message: "Use QuizDelegate instead")
public protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer: Equatable

    typealias AnswerCallback = (Answer) -> Void

    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}

@available(*, deprecated)
public struct Result<Question: Hashable, Answer> {
    public let answers: [Question: Answer]
    public let score: Int
}

@available(*, deprecated, message: "Use Quiz instead ")
public class Game<Question, Answer, R: Router> {
    let flow: Any

    init(flow: Any) {
        self.flow = flow
    }
}

@available(*, deprecated, message: "Use Quiz.start instead")
public func startGame<Question, Answer: Equatable, R: Router>(
    questions: [Question],
    router: R,
    correctAnswers: [Question: Answer]
) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
    let flow = Flow(
        questions: questions,
        delegate: QuizDelegateToRouterAdapter(router, correctAnswers),
        dataSource: QuizDataSourceToRouterAdapter(router, correctAnswers)
    )
    flow.start()
    return Game(flow: flow)
}

@available(*, deprecated, message: "Remove along with the deprecated game types")
private class QuizDelegateToRouterAdapter<R: Router>: QuizDelegate {
    private let router: R
    private let correctAnswers: [R.Question: R.Answer]

    init(_ router: R, _ correctAnswers: [R.Question: R.Answer]) {
        self.router = router
        self.correctAnswers = correctAnswers
    }

    func answer(for question: R.Question, completion: @escaping (R.Answer) -> Void) {
        router.routeTo(question: question, answerCallback: completion)
    }

    func didCompleteQuiz(withAnswers answers: [(question: R.Question, answer: R.Answer)]) {
        let answersDictionary = answers.reduce([R.Question: R.Answer]()) { acc, tuple in
            var acc = acc
            acc[tuple.question] = tuple.answer
            return acc
        }
        let score = scoring(answersDictionary, correctAnswers: correctAnswers)
        let result = Result(answers: answersDictionary, score: score)
        router.routeTo(result: result)
    }

    private func scoring(
        _ answers: [R.Question: R.Answer],
        correctAnswers: [R.Question: R.Answer]
    ) -> Int {
        return answers.reduce(0) { score, tuple in
            return score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
        }
    }
}

@available(*, deprecated, message: "Remove along with the deprecated game types")
private class QuizDataSourceToRouterAdapter<R: Router>: QuizDataSource {
    private let router: R
    private let correctAnswers: [R.Question: R.Answer]

    init(_ router: R, _ correctAnswers: [R.Question: R.Answer]) {
        self.router = router
        self.correctAnswers = correctAnswers
    }

    func answer(for question: R.Question, completion: @escaping (R.Answer) -> Void) {
        router.routeTo(question: question, answerCallback: completion)
    }
}
