//
//  StoryItem.swift
//  Destini
//
//  Created by Tommi Rautava on 19/06/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import Foundation

class StoryItem {
    var text: String
    var answerA: String?
    var answerB: String?
    var nextItemA: StoryItem?
    var nextItemB: StoryItem?

    init(_ text: String, _ answerA: String? = nil, _ answerB: String? = nil, _ nextItemA: StoryItem? = nil, _ nextItemB: StoryItem? = nil) {
        self.text = text
        self.answerA = answerA
        self.answerB = answerB
        self.nextItemA = nextItemA
        self.nextItemB = nextItemB
    }
}
