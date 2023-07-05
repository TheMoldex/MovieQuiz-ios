import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var yesButtonClicked: UIButton!
    @IBOutlet weak private var noButtonClicked: UIButton!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
    ]
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showNextQuestion()
    }
    
    struct QuizQuestion{
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1) /\(questions.count)")
        return questionStep
    }
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    private func showNextQuestion() {
        let currentQuestion = questions[currentQuestionIndex]
        let quizStepViewModel = convert(model: currentQuestion)
        show(quiz: quizStepViewModel)
    }
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.hideAnswerResult()
        }
        if isCorrect {
            correctAnswers += 1
        }
    }
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 { // 1
           let text = "Ваш результат: \(correctAnswers)/10"
           let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть ещё раз")
            showAlert(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            showNextQuestion()
        }
        noButtonClicked.isEnabled = true
        yesButtonClicked.isEnabled = true
    }
    private func showAlert(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    private func hideAnswerResult(){
        imageView.layer.borderWidth = 0
    }

        @IBAction private func yesButtonClicked(_ sender: UIButton) {
            let currentQuestion = questions[currentQuestionIndex]
            let userAnswer = true
            showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
            noButtonClicked.isEnabled = false
            yesButtonClicked.isEnabled = false
        }
        
        @IBAction private func noButtonClicked(_ sender: UIButton) {
            let currentQuestion = questions[currentQuestionIndex]
            let userAnswer = false
            showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
            noButtonClicked.isEnabled = false
            yesButtonClicked.isEnabled = false
        }
}
