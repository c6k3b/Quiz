//  Created by aa on 11/8/22.

import UIKit
import QuizEngine

protocol ViewControllerFactory {
    typealias Answers = [(question: Question<String>, answers: [String])]

    func questionViewController(
        for question: Question<String>,
        answerCallback: @escaping ([String]) -> Void
    ) -> UIViewController

    func resultViewController(for userAnswers: Answers) -> UIViewController

    func resultsViewController(for result: Result<Question<String>, [String]>) -> UIViewController
}

extension ViewControllerFactory {
    func resultViewController(for userAnswers: [(question: Question<String>, answers: [String])]) -> UIViewController {
        return UIViewController()
    }
}
