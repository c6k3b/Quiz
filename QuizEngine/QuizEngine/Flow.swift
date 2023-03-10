// Copyright © 2023 aa. All rights reserved.

final class Flow<Delegate: QuizDelegate> {
	typealias Question = Delegate.Question
	typealias Answer = Delegate.Answer

	private let delegate: Delegate
	private let questions: [Question]
	private var answers: [(Question, Answer)] = []

	init(questions: [Question], delegate: Delegate) {
		self.questions = questions
		self.delegate = delegate
	}

	func start() {
		questionHandling(at: questions.startIndex)
	}
}

private extension Flow {
	func questionHandling(at index: Int) {
		if index < questions.endIndex {
			let question = questions[index]
			delegate.answer(for: question, completion: answer(for: question, at: index))
		} else {
			delegate.didCompleteQuiz(withAnswers: (answers))
		}
	}

	func questionHandling(after index: Int) {
		questionHandling(at: questions.index(after: index))
	}

	func answer(for question: Question, at index: Int) -> (Answer) -> Void {
		return { [weak self] answer in
			self?.answers.replaceOrInsert((question, answer), at: index)
			self?.questionHandling(after: index)
		}
	}
}

private extension Array {
	mutating func replaceOrInsert(_ element: Element, at index: Index) {
		if index < count { remove(at: index) }
		insert(element, at: index)
	}
}
