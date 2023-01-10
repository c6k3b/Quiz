class Flow<R: QuizDelegate> {
    typealias Question = R.Question
    typealias Answer = R.Answer

    private let router: R
    private let questions: [Question]
    private var answers: [Question: Answer] = [:]
    private var scoring: ([Question: Answer]) -> Int

    init(questions: [Question], router: R, scoring: @escaping ([Question: Answer]) -> Int) {
        self.questions = questions
        self.router = router
        self.scoring = scoring
    }

    func start() {
        if let firstQuestion = questions.first {
            router.handle(question: firstQuestion, answerCallback: nextCallback(from: firstQuestion))
        } else {
            router.handle(result: result())
        }
    }

    private func nextCallback(from question: Question) -> (Answer) -> Void {
        return { [weak self] in self?.routeNext(question, $0) }
    }

    private func routeNext(_ question: Question, _ answer: Answer) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            answers[question] = answer
            let nextQuestionIndex = currentQuestionIndex + 1

            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                router.handle(question: nextQuestion, answerCallback: nextCallback(from: nextQuestion))
            } else {
                router.handle(result: result())
            }
        }
    }

    private func result() -> Result<Question, Answer> {
        return Result(answers: answers, score: scoring(answers))
    }
}

//    private extension Flow {
//        func routeToQuestion(at index: Int) {
//            if index < questions.endIndex {
//                let question = questions[index]
//                router.handle(question: question, answerCallback: callback(for: question, at: index))
//            } else {
//                router.handle(result: result())
//            }
//        }
//
//        func routeToQuestion(after index: Int) {
//            routeToQuestion(at: questions.index(after: index))
//        }
//
//        func callback(for question: Question, at index: Int) -> (Answer) -> Void {
//            return { [weak self] answer in
//                self?.answers[question] = answer
//                self?.routeToQuestion(at: index)
//            }
//        }
//    }
