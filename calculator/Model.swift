//
//  Model.swift
//  calculator
//
//  Created by 水代謝システム工学研究室 on 2022/10/11.
//

import Foundation

final class CalculatorModel {
    
    private let changed: (String) -> ()
    
    private(set) var displayNum: String = "0.0" {
        didSet {
            changed(displayNum)
        }
    }
    
    private(set) var num1: Double = 0.0
    private(set) var num2: Double = 0.0
    
    private(set) var how: howToCalc = .none
    private(set) var isChangedHow: Bool = false
    
    private(set) var isCommma: Bool = false
    
    private(set) var results: [Double] = []
    
    private(set) var historyIndex = 0
    
    init(changed: @escaping (String) -> ()) {
        self.changed = changed
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
            result = self.num1 / self.num2
        case .mod:
            result = Double(Int(self.num1) % Int(self.num2))
        case .none:
            return
        }
        
        self.results.append(result)
        self.displayNum = String(result)
        self.how = .none
        self.num1 = result
        self.num2 = 0.0
        self.historyIndex = 0
    }
    
    func tapDelete() {
        var integerPart = String(self.displayNum.split(separator: ".")[0])
        var dicimalPart = String(self.displayNum.split(separator: ".")[1])
        
        if dicimalPart.count != 1 {
            dicimalPart = String(dicimalPart.dropLast())
        } else if dicimalPart.count == 1 && dicimalPart.last != "0" {
            dicimalPart = "0"
        } else if integerPart.count != 1{
            integerPart = String(integerPart.dropLast())
        } else if integerPart.count == 1 {
            integerPart = "0"
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
            self.num1 = results[cnt-self.historyIndex-1]
        } else {
            self.num2 = results[cnt-self.historyIndex-1]
        }
        self.displayNum = String(self.results[cnt-historyIndex-1])
        self.historyIndex = (self.historyIndex + 1) % cnt
    }
    
}

enum howToCalc {
    case plus
    case minus
    case multi
    case div
    case mod
    case none
}
