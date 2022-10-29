//
//  ViewModel.swift
//  calculator
//
//  Created by 水代謝システム工学研究室 on 2022/10/10.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    
    var calculatedNum: Observable<displayInfo> { get }
    var isComma: Observable<Bool> { get }
    var howToCalcChanged: Observable<howToCalc> { get }
    var results: Observable<[Double]> { get }
    
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
    )
}

final class ViewModel: ViewModelType {
    
    let calculatedNum: Observable<displayInfo>
    let isComma: Observable<Bool>
    let howToCalcChanged: Observable<howToCalc>
    let results: Observable<[Double]>
    
    private let model: CalculatorModel
    private let disposeBag = DisposeBag()
    
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
        let _displayCalcInfo = BehaviorRelay<displayCalcInfo>(
            value: displayCalcInfo(
                displayNum: "0.0",
                isComma: false
            )
        )
        let _isComma = BehaviorRelay<Bool>(value: false)
        let _how = BehaviorRelay<howToCalc>(value: .none)
        let _results = BehaviorRelay<[Double]>(value: [0.0])
        
        self.model = CalculatorModel(
            displayNumChanged: { displayNum in _displayCalcInfo.accept(displayNum)},
            isCommaChanged: { isComma in _isComma.accept(isComma)},
            howToCalcChanged: { how in _how.accept(how)},
            resultsChanged: { results in _results.accept(results)}
        )
        
        self.calculatedNum = _displayCalcInfo
            .flatMap({info -> Observable<displayInfo> in
                
                var str: String = info.displayNum
                var at: Int = str.count-1
                var isUnder: Bool = true
                
                let integerPart = String(info.displayNum.split(separator: ".")[0])
                let dicimalPart = String(info.displayNum.split(separator: ".")[1])
                if dicimalPart.count == 1 && dicimalPart == "0" {
                    if info.isComma {
                        str = integerPart + "."
                        at = integerPart.count-1+1
                    } else {
                        str = integerPart
                        at = integerPart.count-1
                        isUnder = false
                    }
                } else if info.isComma == false{
                    at = integerPart.count-1
                } else {
                    isUnder = true
                }
                return .just(displayInfo(
                    num: str,
                    isUnder: isUnder,
                    atUnderline: at))
            })
        
        self.isComma = _isComma
            .flatMap({ bool -> Observable<Bool> in
                return .just(bool)
            })
        
        self.howToCalcChanged = _how
            .flatMap({ how -> Observable<howToCalc> in
                return .just(how)
            })
        
        self.results = _results
            .flatMap({ results -> Observable<[Double]> in
                return .just(results)
            })
        
        plusTaps
            .subscribe(onNext: {[self] in
                self.model.tapHowToCalc(how: .plus)
            })
            .disposed(by: disposeBag)
        
        minusTaps
            .subscribe(onNext: {[self] in
                self.model.tapHowToCalc(how: .minus)
            })
            .disposed(by: disposeBag)
        
        multiTaps
            .subscribe(onNext: {[self] in
                self.model.tapHowToCalc(how: .multi)
            })
            .disposed(by: disposeBag)
        
        divTaps
            .subscribe(onNext: {[self] in
                self.model.tapHowToCalc(how: .div)
            })
            .disposed(by: disposeBag)
        
        modTaps
            .subscribe(onNext: {[self] in
                self.model.tapHowToCalc(how: .pow)
            })
            .disposed(by: disposeBag)
        
        commaTaps
            .subscribe(onNext: {[self] in
                self.model.tapComma()
            })
            .disposed(by: disposeBag)
        
        equalTaps
            .subscribe(onNext: {[self] in
                self.model.tapEqual()
            })
            .disposed(by: disposeBag)
        
        deleteTaps
            .subscribe(onNext: { [self] in
                self.model.tapDelete()
            })
            .disposed(by: disposeBag)
        
        clearTaps
            .subscribe(onNext: { [ self ] in
                self.model.tapClear()
            })
            .disposed(by: disposeBag)
        
        callHistoryTaps
            .subscribe(onNext: { [self] in
                self.model.tapCallHistory()
            })
            .disposed(by: disposeBag)
        
        zeroTaps
            .subscribe(onNext: { [self] in
                self.model.tapNum(n: 0)
            })
            .disposed(by: disposeBag)
        
        oneTaps
            .subscribe(onNext: { [self] in
                self.model.tapNum(n: 1)
            })
            .disposed(by: disposeBag)
        
        twoTaps
            .subscribe(onNext: { [self] in
                self.model.tapNum(n: 2)
            })
            .disposed(by: disposeBag)
        
        threeTaps
            .subscribe(onNext: { [self] in
                self.model.tapNum(n: 3)
            })
            .disposed(by: disposeBag)
        
        fourTaps
            .subscribe(onNext: { [self] in
                self.model.tapNum(n: 4)
            })
            .disposed(by: disposeBag)
        
        fiveTaps
            .subscribe(onNext: { [self] in
                self.model.tapNum(n: 5)
            })
            .disposed(by: disposeBag)
        
        sixTaps
            .subscribe(onNext: { [self] in
                self.model.tapNum(n: 6)
            })
            .disposed(by: disposeBag)
        
        sevenTaps
            .subscribe(onNext: { [self] in
                self.model.tapNum(n: 7)
            })
            .disposed(by: disposeBag)
        
        eightTaps
            .subscribe(onNext: { [self] in
                self.model.tapNum(n: 8)
            })
            .disposed(by: disposeBag)
        
        nineTaps
            .subscribe(onNext: { [self] in
                self.model.tapNum(n: 9)
            })
            .disposed(by: disposeBag)
    }
}
