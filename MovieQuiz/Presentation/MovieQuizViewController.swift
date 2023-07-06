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
        QuizQuestion(image: "The Godfather", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", correctAnswer: true),
        QuizQuestion(image: "The Avengers", correctAnswer: true),
        QuizQuestion(image: "Deadpool", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", correctAnswer: true),
        QuizQuestion(image: "Old", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", correctAnswer: false),
        QuizQuestion(image: "Tesla", correctAnswer: false),
        QuizQuestion(image: "Vivarium", correctAnswer: false)
    ]
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showNextQuestion()
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
        buttonLock(isLock: false)
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
    private func buttonLock(isLock: Bool){
        if isLock == true {
            noButtonClicked.isEnabled = false
            yesButtonClicked.isEnabled = false
        }else{
            noButtonClicked.isEnabled = true
            yesButtonClicked.isEnabled = true
        }
    }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let userAnswer = true
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
        buttonLock(isLock: true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let userAnswer = false
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
        buttonLock(isLock: true)
    }
}
