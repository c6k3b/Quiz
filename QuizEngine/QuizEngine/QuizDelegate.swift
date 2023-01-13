//  QuizDelegate.swift
//  Created by aa on 1/12/23.

public protocol QuizDelegate: AnyObject {
    associatedtype Question: Hashable
    associatedtype Answer

    func answer(for question: Question, completion: @escaping (Answer) -> Void)
    func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)])

    @available(*, deprecated, message: "use didCompleteQuiz(withAnswers:) instead")
    func handle(result: Result<Question, Answer>)
}

#warning("Delete this at some point")
public extension QuizDelegate {
    func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)]) {}
}
