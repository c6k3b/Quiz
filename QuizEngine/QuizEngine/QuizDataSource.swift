// Copyright © 2023 aa. All rights reserved.

public protocol QuizDataSource: AnyObject {
	associatedtype Question
	associatedtype Answer

	func answer(for question: Question, completion: @escaping (Answer) -> Void)
}
