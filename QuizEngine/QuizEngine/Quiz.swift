//  Quiz.swift
//  Created by aa on 1/12/23.

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
