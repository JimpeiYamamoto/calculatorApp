//
//  CalculatorModelTestCase.swift
//  calculatorTests
//
//  Created by 水代謝システム工学研究室 on 2022/10/25.
//

import XCTest
@testable import calculator

final class CalculatorModelTestCase: XCTestCase {
    
    private var model: CalculatorModel!
    private var displayCalcInfo: displayCalcInfo!
    private var isComma: Bool!
    private var how: howToCalc!
    private var results: [Double]!
    
    override func setUp() {
        super.setUp()
        
        self.model = CalculatorModel(
            displayNumChanged: { [weak self] info in self?.displayCalcInfo = info},
            isCommaChanged: { [weak self] bool in self?.isComma = bool},
            howToCalcChanged: { [weak self] how in self?.how = how},
            resultsChanged: { [weak self] results in self?.results = results})
    }
    
    func testInitialValue() {
        XCTAssertEqual(self.model.displayInfo.displayNum, "0.0")
        XCTAssertEqual(self.model.displayInfo.isComma, false)
        XCTAssertEqual(self.model.isCommma, false)
        XCTAssertEqual(self.model.how, .none)
        XCTAssertEqual(self.model.results, [0.0])
        XCTAssertEqual(self.model.num1, 0.0)
        XCTAssertEqual(self.model.num2, 0.0)
        XCTAssertEqual(self.model.isChangedHow, false)
        XCTAssertEqual(self.model.historyIndex, 0)
    }
    
    func testTapNum() {
        XCTAssertEqual(self.model.num1, 0.0)
        model.tapNum(n: 0)
        XCTAssertEqual(self.model.num1, 0.0)
        model.tapNum(n: 1)
        XCTAssertEqual(self.model.num1, 1.0)
        model.tapNum(n: 2)
        XCTAssertEqual(self.model.num1, 12.0)
        model.tapNum(n: 3)
        XCTAssertEqual(self.model.num1, 123.0)
        model.tapNum(n: 4)
        XCTAssertEqual(self.model.num1, 1234.0)
        model.tapNum(n: 5)
        XCTAssertEqual(self.model.num1, 12345.0)
        model.tapNum(n: 6)
        XCTAssertEqual(self.model.num1, 123456.0)
        model.tapNum(n: 7)
        XCTAssertEqual(self.model.num1, 1234567.0)
        model.tapNum(n: 8)
        XCTAssertEqual(self.model.num1, 12345678.0)
        model.tapNum(n: 9)
        XCTAssertEqual(self.model.num1, 123456789.0)
        XCTAssertEqual(self.model.displayNum, "123456789.0")
    }
    
    func testTapHowToCalc() {
        XCTAssertEqual(self.model.how, .none)
        XCTAssertEqual(self.model.num1, 0.0)
        
        model.tapHowToCalc(how: .plus)
        XCTAssertEqual(self.model.how, .plus)
        XCTAssertEqual(self.model.isChangedHow, true)
        
        model.tapNum(n: 9)
        XCTAssertEqual(self.model.num1, 0.0)
        XCTAssertEqual(self.model.num2, 9.0)
        XCTAssertEqual(self.model.isChangedHow, false)
        
        model.tapHowToCalc(how: .minus)
        XCTAssertEqual(self.model.num1, 0.0)
        XCTAssertEqual(self.model.num2, 9.0)
        XCTAssertEqual(self.model.isChangedHow, false)
    }
    
    func testTapComma() {
        XCTAssertEqual(self.model.isCommma, false)
        model.tapComma()
        XCTAssertEqual(self.model.isCommma, true)
        model.tapComma()
        XCTAssertEqual(self.model.isCommma, false)
    }
    
}
