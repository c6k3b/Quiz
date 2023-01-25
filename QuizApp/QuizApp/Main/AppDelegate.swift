// Copyright © 2023 aa. All rights reserved.

import UIKit
import QuizEngine

//@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	var quiz: Quiz?
	
	private lazy var navigationController = UINavigationController()
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
		startNewQuiz()
		return true
	}
	
	private func startNewQuiz() {
		let factory = IOSUIKitViewControllerFactory(options: options, correctAnswers: correctAnswers)
		let router = NavigationControllerRouter(navigationController, factory: factory)

		quiz = Quiz.start(questions: questions, delegate: router)
	}
}
