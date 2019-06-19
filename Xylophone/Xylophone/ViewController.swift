//
//  ViewController.swift
//  Xylophone
//
//  Created by Tommi Rautava on 18/06/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func noteButtonPressed(_ sender: UIButton) {
        playSound(sender.tag)
    }

    func playSound(_ tag: Int) {
        let url = Bundle.main.url(forResource: "note\(tag)", withExtension: "wav")

        do {
            player = try AVAudioPlayer(contentsOf: url!)
            guard let player = player else { return }
            player.delegate = self
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

