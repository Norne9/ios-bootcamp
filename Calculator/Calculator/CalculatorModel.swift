//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Aleksey Pestov on 30.03.2021.
//

import Foundation

enum CalculatorAction {
    case plus
    case minus
    case divide
    case multiply
    case clear
    case sign
    case percent
    case run
}

class Calculator {
    var numberOnScreen: Double = 0
    var numberInMemory: Double = 0
    var tempNumber: String = "0"
    var startedTyping: Bool = false
    var selectedActon: CalculatorAction = .clear
    
    let updateScreen: (String) -> ()
    
    
    init(onUpdate updateScreen: @escaping (String) -> ()) {
        self.updateScreen = updateScreen
    }
    
    func showResult() {
        startedTyping = false
        updateScreen(numToString(num: numberOnScreen))
    }
    
    func numToString(num: Double) -> String {
        String(num)
    }
    
    func sendChar(char mbChar: Character?) {
        let whiteList = "0123456789."
        guard let char = mbChar else {
            return
        }
        if !whiteList.contains(char) {
            return
        }
        
        if !startedTyping {
            tempNumber = ""
        }
        startedTyping = true
        tempNumber += String(char)
        numberOnScreen = Double(tempNumber) ?? 0.0
        updateScreen(tempNumber)
    }
    
    func sendAction(action: CalculatorAction) {
        switch action {
        case .plus, .minus, .divide, .multiply:
            selectedActon = action
            numberInMemory = numberOnScreen
            showResult()
            return
        default:
            break
        }
        
        switch action {
        case .clear:
            numberOnScreen = 0.0
            numberInMemory = 0.0
            showResult()
        case .sign:
            numberOnScreen = -numberOnScreen
            tempNumber = numToString(num: numberOnScreen)
            updateScreen(tempNumber)
        case .percent:
            numberOnScreen /= 100.0
            tempNumber = numToString(num: numberOnScreen)
            updateScreen(tempNumber)
        case .run:
            switch selectedActon {
            case .plus:
                numberInMemory += numberOnScreen
            case .minus:
                numberInMemory -= numberOnScreen
            case .divide:
                numberInMemory /= numberOnScreen
            case .multiply:
                numberInMemory *= numberOnScreen
            default:
                print("Wrong arithmetic action: \(action)")
                break
            }
            numberOnScreen = numberInMemory
            showResult()
        default:
            print("Wrong action: \(action)")
            break
        }
    }
}
