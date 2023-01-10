//  Created by aa on 11/6/22.

public protocol QuizDelegate: AnyObject {
    associatedtype Question: Hashable
    associatedtype Answer

    func handle(question: Question, answerCallback: @escaping (Answer) -> Void)
    func handle(result: Result<Question, Answer>)
}

@available(*, deprecated)
public protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer: Equatable

    typealias AnswerCallback = (Answer) -> Void

    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}
