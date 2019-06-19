//
//  ViewController.swift
//  Quizzler
//
//  Created by Angela Yu on 25/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let allQuestions = QuestionBank()
    var currentQuestion: Int = 0
    var score: Int = 0

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        startOver()
    }

    @IBAction func answerPressed(_ sender: AnyObject) {
        let pickedAnswer = (sender.tag == 1)
        checkAnswer(pickedAnswer)
        nextQuestion()
    }

    func updateUI() {
        questionLabel.text = allQuestions.list[currentQuestion].questionText
        scoreLabel.text = "Score: \(score)"
        progressLabel.text = "\(currentQuestion + 1)/\(allQuestions.list.count)"
        progressBar.frame.size.width = view.frame.size.width / CGFloat(allQuestions.list.count) * CGFloat(currentQuestion + 1)
    }

    func checkAnswer(_ answer: Bool) {
        if (answer == allQuestions.list[currentQuestion].answer) {
            score += 1
            ProgressHUD.showSuccess("Correct!")
        } else {
            ProgressHUD.showError("Wrong!")
        }
    }

    func nextQuestion() {
        if ((currentQuestion + 1) < allQuestions.list.count)
        {
            currentQuestion += 1
            updateUI()
        } else {
            updateUI()
            gameOver()
        }
    }

    func startOver() {
        currentQuestion = 0
        score = 0
        updateUI()
    }

    func gameOver() {
        let alert = UIAlertController(title: "Game Over", message: "Start Over?", preferredStyle: .alert)

        let restartAction = UIAlertAction(title: "Restart", style: .default) {
            (UIAlertAction) in
            self.startOver()
        }

        alert.addAction(restartAction)

        present(alert, animated: true, completion: nil)
    }
}
