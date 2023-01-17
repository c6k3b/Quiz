//  Created by aa on 11/8/22.

import UIKit
import QuizEngine

protocol ViewControllerFactory {
    typealias Answers = [(question: Question<String>, answer: [String])]

    func questionViewController(
        for question: Question<String>,
        answerCallback: @escaping ([String]) -> Void
    ) -> UIViewController

    func resultsViewController(for userAnswers: Answers) -> UIViewController
}
