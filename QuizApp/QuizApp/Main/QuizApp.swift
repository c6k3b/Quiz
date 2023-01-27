// Copyright © 2023 aa. All rights reserved.

import SwiftUI
import QuizEngine

final class QuizAppStore {
	var quiz: Quiz?
}

@main
struct QuizApp: App {
	@StateObject var navigationStore = QuizNavigationStore()
	private let appStore = QuizAppStore()
	
	var body: some Scene {
		WindowGroup {
			QuizNavigationView(store: navigationStore)
				.onAppear { startNewQuiz() }
		}
	}
	
	private func startNewQuiz() {
		let adapter = IOSSwiftUINavigationAdapter(
			navigation: navigationStore,
			options: demoQuiz.options,
			correctAnswers: demoQuiz.correctAnswers,
			playAgain: startNewQuiz
		)
		
		appStore.quiz = Quiz.start(questions: demoQuiz.questions, delegate: adapter)
	}
}
