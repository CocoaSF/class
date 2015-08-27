//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by sbx_fc on 15/8/26.
//  Copyright (c) 2015年 SF. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op : Printable {
        case Operand(Double)
        case UnaryOperration(String,Double->Double)
        case BinaryOperration(String,(Double,Double)->Double)
        
        var description: String { //要实现自己的 description 就得让 enum 实现 CustomStringConvertible 协议。
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperration(let symbol, _):
                    return symbol
                case .BinaryOperration(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knowOps = [String:Op]()
    
    init(){
        knowOps["×"] = Op.BinaryOperration("×", *)
        knowOps["÷"] = Op.BinaryOperration("÷"){ $1 / $0 }
        knowOps["+"] = Op.BinaryOperration("+",+)
        knowOps["−"] = Op.BinaryOperration("−"){ $1 - $0 }
        knowOps["√"] = Op.UnaryOperration("√",sqrt)
    }
    
    private func evaluateCopy(ops:[Op]) ->(result:Double?,remainOps:[Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops;
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return (operand,remainingOps)
            case .UnaryOperration(_,let operation):
                //递归
                let operandEvaluation = evaluateCopy(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainOps)
                }
            case .BinaryOperration(_,let operation):
                let op1Evaluation = evaluateCopy(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluateCopy(op1Evaluation.remainOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1,operand2),op2Evaluation.remainOps)
                    }
                }
            }
        }
        
        return (nil,ops)
    }
    
    /**
    * 求值
    */
    func evaluate()->Double?{
        let (result, remaidner) = evaluateCopy(opStack) //_ 起占位作用，表示我不关心该参数。
        println("\(opStack) = \(result) with \(remaidner) let over")
        return result
    }
    
    func pushOperand(operation:Double) -> Double?{
        opStack.append(Op.Operand(operation))
        return evaluate()
    }
    
    func performOperation(symbol:String) -> Double?{
        if let operation = knowOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
}