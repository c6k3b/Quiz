// Copyright © 2023 aa. All rights reserved.

public struct BasicQuiz {
	public let questions: [Question<String>]
	public let options: [Question<String> : [String]]
	public let correctAnswers: [(Question<String>, [String])]
}

public struct NonEmptyOptions {
	private let head: String
	private let tail: [String]
	
	public init(_ head: String, _ tail: [String]) {
		self.head = head
		self.tail = tail
	}
	
	var all: [String] { [head] + tail }
}

public struct BasicQuizBuilder {
	private var questions: [Question<String>] = []
	private var options: [Question<String> : [String]] = [:]
	private var correctAnswers: [(Question<String>, [String])] = []
	
	public enum AddingError: Equatable, Error {
		case duplicateQuestion(Question<String>)
		case duplicatedOptions([String])
		case duplicatedAnswers([String])
		case missingAnswerInOptions(answer: [String], options: [String])
	}
	
	private init(questions: [Question<String>], options: [Question<String> : [String]], correctAnswers: [(Question<String>, [String])]) {
		self.questions = questions
		self.options = options
		self.correctAnswers = correctAnswers
	}
	
	public init(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
		try add(singleAnswerQuestion: singleAnswerQuestion, options: options, answer: answer)
	}
	
	public init(multipleAnswerQuestion: String, options: NonEmptyOptions, answer: NonEmptyOptions) throws {
		try add(multipleAnswerQuestion: multipleAnswerQuestion, options: options, answer: answer)
	}
}

// MARK: - Public Methods
public extension BasicQuizBuilder {
	mutating func add(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
		self = try adding(singleAnswerQuestion: singleAnswerQuestion, options: options, answer: answer)
	}
	
	mutating func add(multipleAnswerQuestion: String, options: NonEmptyOptions, answer: NonEmptyOptions) throws {
		self = try adding(multipleAnswerQuestion: multipleAnswerQuestion, options: options, answer: answer)
	}
	
	func adding(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws -> BasicQuizBuilder {
		try adding(
			question: Question.singleAnswer(singleAnswerQuestion),
			options: options.all,
			answer: [answer]
		)
	}
	
	func adding(multipleAnswerQuestion: String, options: NonEmptyOptions, answer: NonEmptyOptions) throws -> BasicQuizBuilder {
		try adding(
			question: Question.multipleAnswer(multipleAnswerQuestion),
			options: options.all,
			answer: answer.all
		)
	}
	
	func build() -> BasicQuiz {
		BasicQuiz(questions: questions, options: options, correctAnswers: correctAnswers)
	}
}

// MARK: - Private Methods
private extension BasicQuizBuilder {
	func adding(question: Question<String>, options: [String], answer: [String]) throws -> BasicQuizBuilder {
		guard !questions.contains(question) else {
			throw AddingError.duplicateQuestion(question)
		}
		
		guard Set(options).count == options.count else {
			throw AddingError.duplicatedOptions(options)
		}
		
		guard Set(answer).count == answer.count else {
			throw AddingError.duplicatedAnswers(answer)
		}
		
		guard Set(answer).isSubset(of: Set(options)) else {
			throw AddingError.missingAnswerInOptions(answer: answer, options: options)
		}
		
		var newOptions = self.options
		newOptions[question] = options
		
		return .init(
			questions: questions + [question],
			options: newOptions,
			correctAnswers: correctAnswers + [(question, answer)]
		)
	}
}

// MARK: - Extensions
extension NonEmptyOptions: ExpressibleByArrayLiteral {
	public init(arrayLiteral elements: String...) {
		self.init(elements[0], Array(elements.dropFirst()))
	}
}
