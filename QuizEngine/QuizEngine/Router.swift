//  Created by aa on 11/6/22.

@available(*, deprecated)
public protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer: Equatable

    typealias AnswerCallback = (Answer) -> Void

    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}
