//
//  ViewController.swift
//  Magic 8 Ball
//
//  Created by Tommi Rautava on 18/06/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let ballArray = ["ball1", "ball2", "ball3", "ball4", "ball5"]
    
    var randomBallNumber: Int = 2
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func askButtonPressed(_ sender: UIButton) {
        setRandomBallImage()
    }
    
    func setRandomBallImage() {
        randomBallNumber = Int.random(in: 0 ... ballArray.count - 1)
        
        imageView.image = UIImage(named: ballArray[randomBallNumber])
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        setRandomBallImage()
    }
}

