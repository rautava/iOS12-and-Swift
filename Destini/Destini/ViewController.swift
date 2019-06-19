//
//  ViewController.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Our strings
    let story1 = "Your car has blown a tire on a winding road in the middle of nowhere with no cell phone reception. You decide to hitchhike. A rusty pickup truck rumbles to a stop next to you. A man with a wide brimmed hat with soulless eyes opens the passenger door for you and asks: \"Need a ride, boy?\"."
    let answer1a = "I\'ll hop in. Thanks for the help!"
    let answer1b = "Better ask him if he\'s a murderer first."

    let story2 = "He nods slowly, unphased by the question."
    let answer2a = "At least he\'s honest. I\'ll climb in."
    let answer2b = "Wait, I know how to change a tire."

    let story3 = "As you begin to drive, the stranger starts talking about his relationship with his mother. He gets angrier and angrier by the minute. He asks you to open the glovebox. Inside you find a bloody knife, two severed fingers, and a cassette tape of Elton John. He reaches for the glove box."
    let answer3a = "I love Elton John! Hand him the cassette tape."
    let answer3b = "It\'s him or me! You take the knife and stab him."

    let story4 = "What? Such a cop out! Did you know traffic accidents are the second leading cause of accidental death for most adult age groups?"
    let story5 = "As you smash through the guardrail and careen towards the jagged rocks below you reflect on the dubious wisdom of stabbing someone while they are driving a car you are in."
    let story6 = "You bond with the murderer while crooning verses of \"Can you feel the love tonight\". He drops you off at the next town. Before you go he asks you if you know any good places to dump bodies. You reply: \"Try the pier.\""

    lazy var storyBranch3 = StoryItem(story3, answer3a, answer3b,
                                      StoryItem(story6),
                                      StoryItem(story5))

    lazy var fullStory = StoryItem(story1, answer1a, answer1b,
                                   storyBranch3,
                                   StoryItem(story2, answer2a, answer2b,
                                             storyBranch3,
                                             StoryItem(story4)))

    lazy var currentStoryItem = fullStory

    // UI Elements linked to the storyboard
    @IBOutlet weak var topButton: UIButton!         // Has TAG = 1
    @IBOutlet weak var bottomButton: UIButton!      // Has TAG = 2
    @IBOutlet weak var storyTextView: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }


    // User presses one of the buttons
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            currentStoryItem = currentStoryItem.nextItemA!
        case 2:
            currentStoryItem = currentStoryItem.nextItemB!
        default:
            ()
        }

        if currentStoryItem.answerA == nil {
            currentStoryItem.answerA = "Replay the story"
            currentStoryItem.nextItemA = fullStory
        }

        updateUI()
    }


    func updateUI() {
        storyTextView.text = currentStoryItem.text
        updateButton(topButton, currentStoryItem.answerA)
        updateButton(bottomButton, currentStoryItem.answerB)
    }


    func updateButton(_ button: UIButton, _ answer: String?) {
        if let answer = answer {
            button.setTitle(answer, for: .normal)
            button.isHidden = false
        } else {
            button.setTitle("", for: .disabled)
            button.isHidden = true
        }
    }
}
