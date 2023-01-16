//  DelegateSpy.swift
//  Created by aa on 1/16/23.

import QuizEngine

final class DelegateSpy: QuizDelegate {
    var questionsAsked: [String] = []
    var answerCompletions: [(String) -> Void] = []
    var completedQuizzes = [[(String, String)]]()

    func answer(for question: String, completion: @escaping (String) -> Void) {
        questionsAsked.append(question)
        answerCompletions.append(completion)
    }

    func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
        completedQuizzes.append(answers)
    }
}
