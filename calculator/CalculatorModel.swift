//
//  Model.swift
//  calculator
//
//  Created by 水代謝システム工学研究室 on 2022/10/11.
//

import Foundation

enum howToCalc {
    case plus
    case minus
    case multi
    case div
    case pow
    case none
}

struct displayCalcInfo {
    var displayNum : String
    var isComma: Bool
}

struct displayInfo {
    var num: String
    var isUnder: Bool
    var atUnderline: Int
}

final class CalculatorModel {
    
    private let displayNumChanged: (displayCalcInfo) -> ()
    private let isCommandChanged: (Bool) -> ()
    private let howToCalcChanged: (howToCalc) -> ()
    private let resultsChanged: ([Double]) -> ()
    
    
    private(set) var displayInfo: displayCalcInfo = displayCalcInfo(
        displayNum: "0.0",
        isComma: false) {
        didSet {
            displayNumChanged(displayInfo)
        }
    }
    
    private(set) var displayNum : String = "0.0"{
        didSet {
            self.displayInfo.displayNum = displayNum
        }
    }
    
    private(set) var isCommma: Bool = false {
        didSet {
            self.isCommandChanged(isCommma)
            self.displayInfo.isComma = isCommma
        }
    }
    
    private(set) var how: howToCalc = .none {
        didSet {
            self.howToCalcChanged(how)
        }
    }
    
    private(set) var results: [Double] = [0.0] {
        didSet {
            self.resultsChanged(results)
        }
    }
    
    private(set) var num1: Double = 0.0
    private(set) var num2: Double = 0.0
    
    private(set) var isChangedHow: Bool = false
    
    private(set) var historyIndex = 0
    
    init(
        displayNumChanged: @escaping (displayCalcInfo) -> (),
        isCommaChanged: @escaping (Bool) -> (),
        howToCalcChanged: @escaping (howToCalc) -> (),
        resultsChanged: @escaping ([Double]) -> ()
    ) {
        self.displayNumChanged = displayNumChanged
        self.isCommandChanged = isCommaChanged
        self.howToCalcChanged = howToCalcChanged
        self.resultsChanged = resultsChanged
    }
    
    func tapNum(n: Double) {
        
        if self.isChangedHow {
            self.displayNum = String(num2)
            self.isChangedHow = false
        }
        
        var integerPart = String(self.displayNum.split(separator: ".")[0])
        var dicimalPart = String(self.displayNum.split(separator: ".")[1])
        
        if self.isCommma {
            if dicimalPart.count == 1 && dicimalPart.last == "0"  &&  n != 0.0{
                dicimalPart = String(Int(n))
            } else {
                dicimalPart.append(contentsOf: String(Int(n)))
            }
        } else {
            if integerPart.first == "0" {
                integerPart =  String(Int(n))
            } else {
                integerPart.append(contentsOf: String(Int(n)))
            }
        }
        
        self.displayNum = String(integerPart + "." + dicimalPart)
        guard let doubleNum = Double(self.displayNum) else { return }
        
        if self.how == .none {
            self.num1 = doubleNum
        } else {
            self.num2 = doubleNum
        }
    }
    
    func tapHowToCalc(how: howToCalc) {
        if self.how == .none {
            self.isChangedHow = true
        }
        self.isCommma = false
        self.how = how
    }
    
    func tapComma() {
        self.isCommma = !self.isCommma
    }
    
    func tapEqual() {
        var result = 0.0
        
        switch self.how {
        case .plus:
            result = self.num1 + self.num2
        case .minus:
            result = self.num1 - self.num2
        case .multi:
            result = self.num1 * self.num2
        case .div:
            if self.num2 != 0 {
                result = self.num1 / self.num2
            }
        case .pow:
            result = pow(self.num1, self.num2)
        case .none:
            return
        }
        
        setResults(new: result)
        self.displayNum = String(result)
        self.how = .none
        self.num1 = result
        self.num2 = 0.0
        self.historyIndex = 0
    }
    
    func setResults(new: Double) {
        var ret = self.results
        
        if ret.contains(new) == false {
            ret.append(new)
        }
        if ret.count == 5 {
            _ = ret.remove(at: 0)
        }
        self.results = ret
    }
    
    func tapDelete() {
        var integerPart = String(self.displayNum.split(separator: ".")[0])
        var dicimalPart = String(self.displayNum.split(separator: ".")[1])
        
        if self.isCommma {
            if dicimalPart.count != 1 {
                dicimalPart = String(dicimalPart.dropLast())
            } else if dicimalPart.count == 1 && dicimalPart.last != "0" {
                dicimalPart = "0"
            }
        } else {
            if integerPart.count != 1 {
                integerPart = String(integerPart.dropLast())
            } else if integerPart.count == 1 && integerPart.last != "0" {
                integerPart = "0"
            }
        }
        self.displayNum = String(integerPart + "." + dicimalPart)
        
        guard let doubleNum = Double(self.displayNum) else { return }
        if self.how == .none {
            self.num1 = doubleNum
        } else {
            self.num2 = doubleNum
        }
    }
    
    func tapClear() {
        self.num1 = 0.0
        self.num2 = 0.0
        self.isCommma = false
        self.how = .none
        self.displayNum = String(self.num1)
        self.historyIndex = 0
    }
    
    func tapCallHistory() {
        let cnt = self.results.count
        if cnt == 0 {
            return
        }
        if self.how == .none {
            if self.num1 == results[cnt-self.historyIndex-1] {
                self.historyIndex = (self.historyIndex + 1) % cnt
            }
            self.num1 = results[cnt-self.historyIndex-1]
        } else {
            if self.num2 == results[cnt-self.historyIndex-1] {
                self.historyIndex = (self.historyIndex + 1) % cnt
            }
            self.num2 = results[cnt-self.historyIndex-1]
        }
        self.displayNum = String(self.results[cnt-historyIndex-1])
        self.historyIndex = (self.historyIndex + 1) % cnt
    }
    
}
