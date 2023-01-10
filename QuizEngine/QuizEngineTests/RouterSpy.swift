//  Created by aa on 11/6/22.

@testable import QuizEngine

class RouterSpy: Router {
    var routedQuestions: [String] = []
    var routedResult: Result<String, String>?
    var answerCallback: (String) -> Void = { _ in }

    func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
        routedQuestions.append(question)
        self.answerCallback = answerCallback
    }

    func routeTo(result: Result<String, String>) {
        routedResult = result
    }
}
