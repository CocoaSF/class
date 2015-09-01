//
//  ViewController.swift
//  Calculator
//
//  Created by sbx_fc on 15/8/25.
//  Copyright (c) 2015年 SF. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton){
        let digit = sender.currentTitle!;
        if(userIsInTheMiddleOfTypingANumber){
            display.text = display!.text! + digit;
        }
        else{
            display.text = digit;
            userIsInTheMiddleOfTypingANumber = true;
        }
    }
    
    var operandStack = [Double]()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false;
        //operandStack.append(displayValue) 
        //println("oprendStack = \(operandStack)")
        if let result = brain.pushOperand(displayValue){
            displayValue = result;
        }
        else{
            displayValue = 0;
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let result = brain.performOperation(operation){
            displayValue = result
        }
        else{
            displayValue = 0
        }
        
//        switch operation{
//        case "×":preformOperation {$0*$1}
//        case "÷":preformOperation {$1/$0}
//        case "+":preformOperation {$0+$1}
//        case "−":preformOperation {$1-$0}
//        case "√":preformOperationCopy {sqrt($0)}
//        default : break;
//        }
        
    }
    
    func preformOperation(operation:(Double,Double) -> Double){
        
        if operandStack.count >= 2{
            displayValue = operation(operandStack.removeLast(),operandStack.removeLast())
            enter()
            
        }
    }
    
    //Xcode 6.3 这里出错
    //func preformOperation(operation : Double -> Double){
    func preformOperationCopy(operation : Double -> Double){
        
        if operandStack.count >= 1{
            displayValue = operation(operandStack.removeLast())
            enter()
            
        }
    }
    
    
    var displayValue:Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false;
        }
    }
}

