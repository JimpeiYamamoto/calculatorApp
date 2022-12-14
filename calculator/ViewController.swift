//
//  ViewController.swift
//  calculator
//
//  Created by 水代謝システム工学研究室 on 2022/10/10.
// https://colorhunt.co/palette/4834346b4f4feed6c4fff3e4

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
    
    @IBOutlet weak var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    
    
    func setColor(uiItems: [UIButton], hex: String) {
        for item in uiItems {
            item.backgroundColor = UIColor.init(hex: hex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor(
            uiItems: [
                zero, one, two, three, four, five, six, seven, eight, nine, comma
            ],
            hex: "6B4F4F"
        )
        
        setColor(
            uiItems: [
                delete, clear, mod, div, multi, minus, plus, equal, call
            ],
            hex: "483434"
        )
        numLabel.backgroundColor = UIColor.init(hex: "483434")
        tableView.backgroundColor = UIColor.init(hex: "483434")
        self.view.backgroundColor = UIColor.init(hex: "EED6C4")
        
        let viewModel: ViewModelType = ViewModel(
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
            .bind(to: self.numLabel.rx.calculatedNum)
            .disposed(by: self.disposeBag)
        
        viewModel.isComma
            .bind(to: self.comma.rx.isComma)
            .disposed(by: self.disposeBag)
        
        viewModel.howToCalcChanged
            .bind(to: self.plus.rx.isPlus)
            .disposed(by: self.disposeBag)
        
        viewModel.howToCalcChanged
            .bind(to: self.minus.rx.isMinus)
            .disposed(by: self.disposeBag)
        
        viewModel.howToCalcChanged
            .bind(to: self.multi.rx.isMulti)
            .disposed(by: self.disposeBag)
        
        viewModel.howToCalcChanged
            .bind(to: self.div.rx.isDiv)
            .disposed(by: self.disposeBag)
        
        viewModel.howToCalcChanged
            .bind(to: self.mod.rx.isMod)
            .disposed(by: self.disposeBag)
        
        viewModel.results
            .bind(to: self.tableView.rx.items(cellIdentifier: "Cell")) { row, element, cell in
                cell.selectionStyle = .none
                cell.textLabel?.font = UIFont.systemFont(ofSize: 25)
                cell.backgroundColor = UIColor.init(hex: "483434")
                cell.textLabel?.textAlignment = .right
                cell.textLabel?.text = String(element)
            }
            .disposed(by: disposeBag)
    }
    
}

extension Reactive where Base: UILabel {
    
    var calculatedNum: Binder<displayInfo> {
        return Binder(base) { label, result  in
            label.text = result.num
            label.textColor = .white
            if result.isUnder {
                let text = NSMutableAttributedString(string: result.num)
                text.addAttributes([
                    .foregroundColor: UIColor.init(hex: "EED6C4")
                ],range: NSMakeRange(result.atUnderline, 1))
                label.attributedText = text
            }
        }
    }
    
}

extension Reactive where Base: UIButton {
    
    var isComma: Binder<Bool> {
        return Binder(base) { button, result in
            button.setEmphasis(isEmphasis: result)
        }
    }
    
    var isPlus: Binder<howToCalc> {
        return Binder(base) { button, result in
            button.setEmphasis(isEmphasis: result == .plus)
        }
    }
    
    var isMinus: Binder<howToCalc> {
        return Binder(base) { button, result in
            button.setEmphasis(isEmphasis: result == .minus)
        }
    }
    
    var isMulti: Binder<howToCalc> {
        return Binder(base) { button, result in
            button.setEmphasis(isEmphasis: result == .multi)
        }
    }
    
    var isDiv: Binder<howToCalc> {
        return Binder(base) { button, result in
            button.setEmphasis(isEmphasis: result == .div)
        }
    }
    
    var isMod: Binder<howToCalc> {
        return Binder(base) { button, result in
            button.setEmphasis(isEmphasis: result == .pow)
        }
    }
    
}

extension UIButton {
    
    func setEmphasis(isEmphasis: Bool) {
        if isEmphasis {
            self.layer.borderWidth = 5.0
            self.layer.borderColor = UIColor.init(hex: "FFF3E4").cgColor
        } else {
            self.layer.borderWidth = 0.0
            self.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
