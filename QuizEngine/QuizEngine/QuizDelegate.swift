//  QuizDelegate.swift
//  Created by aa on 1/12/23.

public protocol QuizDelegate: AnyObject {
    associatedtype Question
    associatedtype Answer

    func answer(for question: Question, completion: @escaping (Answer) -> Void)
    func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)])
}
