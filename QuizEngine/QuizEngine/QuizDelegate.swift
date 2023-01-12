//  QuizDelegate.swift
//  Created by aa on 1/12/23.

public protocol QuizDelegate: AnyObject {
    associatedtype Question: Hashable
    associatedtype Answer

    func handle(question: Question, answerCallback: @escaping (Answer) -> Void)
    func handle(result: Result<Question, Answer>)
}
