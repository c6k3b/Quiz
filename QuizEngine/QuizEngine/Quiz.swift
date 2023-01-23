// Copyright © 2023 aa. All rights reserved.

public final class Quiz {
	private let flow: Any

	private init(flow: Any) {
		self.flow = flow
	}

	public static func start<Delegate: QuizDelegate, DataSource: QuizDataSource>(
		questions: [DataSource.Question],
		delegate: Delegate,
		dataSource: DataSource
	) -> Quiz where Delegate.Answer: Equatable {
		let flow = Flow(questions: questions, delegate: delegate, dataSource: dataSource)
		flow.start()
		return Quiz(flow: flow)
	}
}
