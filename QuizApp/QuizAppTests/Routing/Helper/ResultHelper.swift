//  ResultHelper.swift
//  Created by aa on 11/10/22.

@testable import QuizEngine

extension Result {
    static func make(answers: [Question: Answer] = [:], score: Int = 0) -> Result {
        return Result(answers: answers, score: score)
    }
}

extension Result: Equatable where Answer: Equatable {
   public static func == (lhs: Result, rhs: Result) -> Bool {
       return lhs.score == rhs.score && lhs.answers == rhs.answers
   }
}

extension Result: Hashable where Answer: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(answers)
        hasher.combine(score)
    }
}
