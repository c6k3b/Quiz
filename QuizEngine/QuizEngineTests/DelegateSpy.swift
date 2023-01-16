//  DelegateSpy.swift
//  Created by aa on 1/16/23.

import QuizEngine

final class DelegateSpy: QuizDelegate {
    var completedQuizzes = [[(String, String)]]()

    func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
        completedQuizzes.append(answers)
    }
}
