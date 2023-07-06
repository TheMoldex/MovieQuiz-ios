
import Foundation
import UIKit

struct QuizQuestion{
    let image: String
    let text: String = "Рейтинг этого фильма больше чем 6?"
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
