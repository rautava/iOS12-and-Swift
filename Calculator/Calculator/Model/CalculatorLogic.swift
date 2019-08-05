//
//  CalculatorLogic.swift
//  Calculator
//
//  Created by Tommi Rautava on 05/08/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation

struct CalculatorLogic {
    private var number: Double = 0
    private var intermediateCalculation: (number: Double, calcMethod: String)?
    private var prevInputWasCalcMethod = false

    mutating func setInputNumber(_ number: Double) {
        self.number = number
        prevInputWasCalcMethod = false
    }

    mutating func clear() {
        number = 0
        intermediateCalculation = nil
        prevInputWasCalcMethod = false
    }

    mutating func calculate(calcMethod: String) -> Double {
        switch calcMethod {
        case "C":
            clear()
        case "±":
            number *= -1
        case "%":
            number *= 0.01
        case "÷", "×", "-", "+":
            // Perform a pending calculation, if any.
            if !prevInputWasCalcMethod {
                calculateWithTwoNumbers()
            }

            prevInputWasCalcMethod = true
            intermediateCalculation = (number: number, calcMethod: calcMethod)
        case "=":
            calculateWithTwoNumbers()
        default:
            fatalError("Unknown key pressed: \(calcMethod)")
        }

        return number
    }

    private mutating func calculateWithTwoNumbers() {
        if let intermediateCalculation = intermediateCalculation {
            switch intermediateCalculation.calcMethod {
            case "÷":
                number = intermediateCalculation.number / number
            case "×":
                number = intermediateCalculation.number * number
            case "-":
                number = intermediateCalculation.number - number
            case "+":
                number = intermediateCalculation.number + number
            default:
                fatalError("Unknown calculation method: '\(intermediateCalculation.calcMethod)'")
            }

            self.intermediateCalculation = nil
        }
    }
}
