//
//  ViewController.swift
//  Caculator
//
//  Created by 李正宁 on 6/13/15.
//  Copyright (c) 2015 Zhengning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    var brain = CaculatorBrain()
    let decimalSeparator = NSNumberFormatter().decimalSeparator!
    
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            if (digit == decimalSeparator) && (display.text!.rangeOfString(decimalSeparator) != nil) {
                return
            }
            if (digit == "0") && ((display.text == "0") || (display.text == "-0")){
                return
            }
            if (digit != decimalSeparator) && ((display.text == "0") || (display.text
                == "-0")) {
                    if (display.text == "0") {
                        display.text = digit
                    } else {
                        display.text = "-" + digit
                    }
            } else {
                display.text = display.text! + digit
            }
        } else {
            if digit == decimalSeparator {
                display.text = "0" + decimalSeparator
            } else {
                display.text = digit
            }
            userIsInTheMiddleOfTypingANumber = true
            historyLabel.text = brain.showStack()
        }
        
    }
   
    @IBAction func operate(sender: UIButton) {
        if let operation = sender.currentTitle {
            if userIsInTheMiddleOfTypingANumber {
                if operation == "±" {
                    let displayText = display.text!
                    if (displayText.rangeOfString("-") != nil) {
                        display.text = dropFirst(displayText)
                    } else {
                        display.text = "-" + displayText
                    }
                    return
                }
                enter()
            }
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    @IBAction func setM(sender: UIButton) {
        if let variable = last(sender.currentTitle!){
            if displayValue != nil {
                brain.variableValues["\(variable)"] = displayValue
                if let result = brain.evaluate() {
                    displayValue = result
                } else {
                    displayValue = nil
                }
            }
        }
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func pushM(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let result = brain.pushOperand(sender.currentTitle!) {
            displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        displayValue = nil
        historyLabel.text = ""
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            if (newValue != nil) {
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .DecimalStyle
                numberFormatter.maximumFractionDigits = 10
                display.text = numberFormatter.stringFromNumber(newValue!)
            } else {
                display.text = " "
            }
            userIsInTheMiddleOfTypingANumber = false
            
            let stack = brain.showStack()
            if !stack!.isEmpty {
                historyLabel.text = join(decimalSeparator, stack!.componentsSeparatedByString(".")) + " ="
                
            }
        }
    }
    
}


