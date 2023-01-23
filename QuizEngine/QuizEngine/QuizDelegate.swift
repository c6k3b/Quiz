// Copyright © 2023 aa. All rights reserved.

public protocol QuizDelegate: AnyObject {
	associatedtype Question
	associatedtype Answer

	func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)])
}
