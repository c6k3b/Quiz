import UIKit
import QuizEngine

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var quiz: Quiz?

    private lazy var navigationController = UINavigationController()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        startNewQuiz()

        return true
    }

    private func startNewQuiz() {
        let question1 = Question.singleAnswer("What's Mike's nationality?")
        let question2 = Question.multipleAnswer("What are Caio's nationalities?")
        let questions = [question1, question2]

        let option1 = "Canadian"
        let option2 = "American"
        let option3 = "Greek"
        let options1 = [option1, option2, option3]

        let option4 = "Portuguese"
        let option5 = "American"
        let option6 = "Brazilian"
        let options2 = [option4, option5, option6]

        let options = [question1: options1, question2: options2]
        let correctAnswers = [(question1, [option3]), (question2, [option4, option6])]

        // MARK: - SwiftUI Implementation
//        let adapter = IOSSwiftUINavigationAdapter(
//            show: { [navigationController] in
//                $0.modalPresentationStyle = .fullScreen
//                navigationController.topModal.present($0, animated: true)
//            },
//            options: options,
//            correctAnswers: correctAnswers,
//            playAgain: startNewQuiz
//        )

//        quiz = Quiz.start(questions: questions, delegate: adapter, dataSource: adapter)

        // MARK: - UIKit Implementation
        let factory = IOSUIKitViewControllerFactory(options: options, correctAnswers: correctAnswers)
        let router = NavigationControllerRouter(navigationController, factory: factory)

        quiz = Quiz.start(questions: questions, delegate: router, dataSource: router)
    }
}

private extension UIViewController {
    var topModal: UIViewController {
        presentedViewController?.topModal ?? self
    }
}
