//  DataSourceSpy.swift
//  Created by aa on 1/16/23.

import QuizEngine

final class DataSourceSpy: QuizDataSource {
    var questionsAsked: [String] = []
    var answerCompletions: [(String) -> Void] = []

    func answer(for question: String, completion: @escaping (String) -> Void) {
        questionsAsked.append(question)
        answerCompletions.append(completion)
    }
}
