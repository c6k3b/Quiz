//  QuizDataSource.swift
//  Created by aa on 1/16/23.

public protocol QuizDataSource: AnyObject {
    associatedtype Question
    associatedtype Answer

    func answer(for question: Question, completion: @escaping (Answer) -> Void)
}
