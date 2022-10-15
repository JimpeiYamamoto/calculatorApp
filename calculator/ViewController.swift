//
//  ViewController.swift
//  calculator
//
//  Created by 水代謝システム工学研究室 on 2022/10/10.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var numLabel: UILabel!
    
    @IBOutlet weak var zero: UIButton!
    @IBOutlet weak var one: UIButton!
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var three: UIButton!
    @IBOutlet weak var four: UIButton!
    @IBOutlet weak var five: UIButton!
    @IBOutlet weak var six: UIButton!
    @IBOutlet weak var seven: UIButton!
    @IBOutlet weak var eight: UIButton!
    @IBOutlet weak var nine: UIButton!
    
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var comma: UIButton!
    @IBOutlet weak var equal: UIButton!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var multi: UIButton!
    @IBOutlet weak var div: UIButton!
    @IBOutlet weak var mod: UIButton!
    
    @IBOutlet weak var call: UIButton!
    @IBOutlet weak var clear: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = ViewModel(
            zeroTaps: zero.rx.tap.asObservable(),
            oneTaps: one.rx.tap.asObservable(),
            twoTaps: two.rx.tap.asObservable(),
            threeTaps: three.rx.tap.asObservable(),
            fourTaps: four.rx.tap.asObservable(),
            fiveTaps: five.rx.tap.asObservable(),
            sixTaps: six.rx.tap.asObservable(),
            sevenTaps: seven.rx.tap.asObservable(),
            eightTaps: eight.rx.tap.asObservable(),
            nineTaps: nine.rx.tap.asObservable(),
            equalTaps: equal.rx.tap.asObservable(),
            plusTaps: plus.rx.tap.asObservable(),
            minusTaps: minus.rx.tap.asObservable(),
            multiTaps: multi.rx.tap.asObservable(),
            divTaps: div.rx.tap.asObservable(),
            modTaps: mod.rx.tap.asObservable(),
            commaTaps: comma.rx.tap.asObservable(),
            deleteTaps: delete.rx.tap.asObservable(),
            clearTaps: clear.rx.tap.asObservable(),
            callHistoryTaps: call.rx.tap.asObservable()
        )
        
        viewModel.calculatedNum
            .bind(to: numLabel.rx.calculatedNum)
            .disposed(by: disposeBag)
        
    }
}

extension Reactive where Base: UILabel {
    
    var calculatedNum: Binder<String> {
        return Binder(base) { label, result  in
            label.text = result.description
        }
    }
    
}