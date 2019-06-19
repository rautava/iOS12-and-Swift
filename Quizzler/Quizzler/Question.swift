//
//  Question.swift
//  Quizzler
//
//  Created by Tommi Rautava on 19/06/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import Foundation

class Question {
    let questionText: String
    let answer: Bool

    init(text: String, correctAnswer: Bool) {
        questionText = text
        answer = correctAnswer
    }
}
