//
//  ViewModel.swift
//  calculator
//
//  Created by 水代謝システム工学研究室 on 2022/10/10.
//

import Foundation
import RxSwift
import RxCocoa

final class ViewModel {
    
    let calculatedNum: Observable<String>
    let isComma: Observable<Bool>
    let howToCalcChanged: Observable<howToCalc>
    
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
        let _displayNum = BehaviorRelay<String>(value: "0.0")
        let _isComma = BehaviorRelay<Bool>(value: false)
        let _how = BehaviorRelay<howToCalc>(value: .none)
        
        self.model = CalculatorModel(
            displayNumChanged: { displayNum in _displayNum.accept(displayNum)},
            isCommaChanged: { isComma in _isComma.accept(isComma)},
            howToCalcChanged: { how in _how.accept(how)}
        )
        
        self.calculatedNum = _displayNum
            .flatMap({ [weak model] num -> Observable<String> in
                guard let model = model else { return .empty()}
                return .just(String(model.displayNum))
            })
        
        self.isComma = _isComma
            .flatMap({ [weak model] bool -> Observable<Bool> in
                guard let model = model else { return .empty()}
                return .just(model.isCommma)
            })
        
        self.howToCalcChanged = _how
            .flatMap({ [weak model] how -> Observable<howToCalc> in
                guard let model = model else { return .empty()}
                return .just(model.how)
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
                self.model.tapHowToCalc(how: .mod)
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
