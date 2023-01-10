//  QuestionPresenter.swift
//  Created by aa on 11/10/22.
import QuizEngine

struct QuestionPresenter {
    let questions: [Question<String>]
    let question: Question<String>

    var title: String {
        guard let index = questions.firstIndex(of: question) else { return "" }
        return "Question #\(index + 1)"
    }
}
