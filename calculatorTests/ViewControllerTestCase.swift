//
//  ViewControllerTestCase.swift
//  calculatorTests
//
//  Created by 水代謝システム工学研究室 on 2022/11/03.
//

import Foundation
import RxSwift
import RxCocoa
import XCTest
@testable import calculator

final class ViewModelMock: ViewModelType {
    var calculatedNum: Observable<displayInfo>
    let _calculatedNum = PublishRelay<displayInfo>()
    
    var isComma: Observable<Bool>
    let _isComma = PublishRelay<Bool>()
    
    var howToCalcChanged: Observable<howToCalc>
    let _howToCalcChanged = PublishRelay<howToCalc>()
    
    var results: Observable<[Double]>
    let _results = PublishRelay<[Double]>()
    
    private let disposeBag = DisposeBag()
    
    private(set) var zeroButtonTapCount: Int = 0
    
    init(
        zeroTaps: Observable<Void>,
        oneTaps: Observable<Void>,
        twoTaps: Observable<Void>,
        threeTaps: Observable<Void>,
        fourTaps: Observable<Void>,
        fiveTaps: Observable<Void>,
        sixTaps: Observable<Void>,
        sevenTaps: Observable<Void>,
        eightTaps: Observable<Void>,
        nineTaps: Observable<Void>,
        equalTaps: Observable<Void>,
        plusTaps: Observable<Void>,
        minusTaps: Observable<Void>,
        multiTaps: Observable<Void>,
        divTaps: Observable<Void>,
        modTaps: Observable<Void>,
        commaTaps: Observable<Void>,
        deleteTaps: Observable<Void>,
        clearTaps: Observable<Void>,
        callHistoryTaps: Observable<Void>
    ) {
        self.calculatedNum = _calculatedNum.asObservable()
        self.isComma = _isComma.asObservable()
        self.howToCalcChanged = _howToCalcChanged.asObservable()
        self.results = _results.asObservable()
        
        zeroTaps
            .subscribe(onNext: { [weak self] in
                self?.zeroButtonTapCount += 1
            })
            .disposed(by: disposeBag)
    }
    
    
}

final class ViewControllerTestCase: XCTestCase {
    
    private var viewController: ViewController!
    private var viewModel: ViewModelMock!
    private var calculatedNum: PublishRelay<displayInfo>!
    
    override func setUp() {
        super.setUp()
        
        let viewController = ViewController()
        _ = viewController.view
        self.viewController = viewController
        
        self.viewModel = ViewModelMock(
            zeroTaps: self.viewController.zero.rx.tap.asObservable(),
            oneTaps: self.viewController.one.rx.tap.asObservable(),
            twoTaps: self.viewController.two.rx.tap.asObservable(),
            threeTaps: self.viewController.three.rx.tap.asObservable(),
            fourTaps: self.viewController.four.rx.tap.asObservable(),
            fiveTaps: self.viewController.five.rx.tap.asObservable(),
            sixTaps: self.viewController.six.rx.tap.asObservable(),
            sevenTaps: self.viewController.seven.rx.tap.asObservable(),
            eightTaps: self.viewController.eight.rx.tap.asObservable(),
            nineTaps: self.viewController.nine.rx.tap.asObservable(),
            equalTaps: self.viewController.equal.rx.tap.asObservable(),
            plusTaps: self.viewController.plus.rx.tap.asObservable(),
            minusTaps: self.viewController.minus.rx.tap.asObservable(),
            multiTaps: self.viewController.multi.rx.tap.asObservable(),
            divTaps: self.viewController.div.rx.tap.asObservable(),
            modTaps: self.viewController.mod.rx.tap.asObservable(),
            commaTaps: self.viewController.comma.rx.tap.asObservable(),
            deleteTaps: self.viewController.delete.rx.tap.asObservable(),
            clearTaps: self.viewController.clear.rx.tap.asObservable(),
            callHistoryTaps: self.viewController.call.rx.tap.asObservable()
        )
        self.calculatedNum = self.viewModel._calculatedNum
    }
    
    func testTapZero() {
        calculatedNum.accept(
            displayInfo(num: "0.0", isUnder: false, atUnderline: 0)
            
        )
        XCTAssertEqual(viewController.numLabel.text, "0")
    }
}
