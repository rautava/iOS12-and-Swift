//
//  ViewController.swift
//  Calculator
//
//  Created by Angela Yu on 10/09/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

fileprivate let positiveInfinity = "∞"
fileprivate let negativeInfinity = "-∞"

class ViewController: UIViewController {
    @IBOutlet var displayLabel: UILabel!

    private var calculator = CalculatorLogic()

    private var displayValue: Double {
        get {
            guard let number = Double(displayLabel.text!) else {
                switch displayLabel.text! {
                case positiveInfinity:
                    return Double.infinity
                case negativeInfinity:
                    return -Double.infinity
                default:
                    fatalError("Could not convert to a Double.")
                }
            }
            return number
        }

        set {
            displayLabel.text = newValue.asString
        }
    }

    private var isFinishedTypingNumber: Bool = true

    @IBAction func calcButtonPressed(_ sender: UIButton) {
        if !isFinishedTypingNumber {
            isFinishedTypingNumber = true
            calculator.setInputNumber(displayValue)
        }

        if let calcMethod = sender.currentTitle {
            displayValue = calculator.calculate(calcMethod: calcMethod)
        }
    }

    @IBAction func numButtonPressed(_ sender: UIButton) {
        if let numValue = sender.currentTitle {
            if isFinishedTypingNumber {
                isFinishedTypingNumber = numValue == "0"

                if numValue == "." {
                    displayLabel.text = "0."
                } else {
                    displayLabel.text = numValue
                }
            } else {
                if numValue == "." {
                    let isInt = (floor(displayValue) == displayValue)

                    if !isInt {
                        return
                    }
                }

                displayLabel.text?.append(contentsOf: numValue)
            }
        }
    }
}

extension Double {
    var asString: String {
        if floor(self) == self {
            switch self {
            case Double.infinity:
                return positiveInfinity
            case -Double.infinity:
                return negativeInfinity
            default:
                return String(Int(self))
            }
        }

        return String(self)
    }
}
