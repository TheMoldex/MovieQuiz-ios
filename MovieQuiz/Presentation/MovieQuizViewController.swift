import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var yesButtonClicked: UIButton!
    @IBOutlet weak private var noButtonClicked: UIButton!

    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
    }
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let quizStepViewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: quizStepViewModel)
        }
    }
    // MARK: - Private functions
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1) /\(questionsAmount)")
        return questionStep
    }
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    private func showNextQuestion() {
        questionFactory?.requestNextQuestion()
    }
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.hideAnswerResult()
        }
        if isCorrect {
            correctAnswers += 1
        }
    }
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 { // 1
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
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else {return}
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    private func hideAnswerResult() {
        imageView.layer.borderWidth = 0
    }
    private func buttonLock(isLock: Bool) {
        if isLock == true {
            noButtonClicked.isEnabled = false
            yesButtonClicked.isEnabled = false
        } else {
            noButtonClicked.isEnabled = true
            yesButtonClicked.isEnabled = true
        }
    }
    // MARK: - Action
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard  let currentQuestion = currentQuestion else {
            return
        }
        let userAnswer = true
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
        buttonLock(isLock: true)
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard  let currentQuestion = currentQuestion else {
            return
        }
        let userAnswer = false
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
        buttonLock(isLock: true)
    }
}
