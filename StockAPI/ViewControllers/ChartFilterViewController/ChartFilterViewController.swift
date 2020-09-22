//
//  ChartFilterViewController.swift
//  StockAPI
//
//  Created by Voro on 20.09.20.
//

import UIKit
import DropDown
import RxSwift
import RxCocoa
import RxSwiftExt

class ChartFilterViewController: UIViewController {
    
    @IBOutlet weak var filterButtonLeft1: UIButton!
    @IBOutlet weak var filterButtonLeft2: UIButton!
    @IBOutlet weak var filterButtonRight: UIButton!
    
    let disposeBag = DisposeBag()
    let left1DropDown = DropDown()
    let left2DropDown = DropDown()
    let rightDropDown = DropDown()
    
    private let selectedLeft1 = BehaviorSubject<String?>(value: nil)
    private let selectedLeft2 = BehaviorSubject<String?>(value: nil)
    private let selectedRight = BehaviorSubject<String?>(value: nil)
    
    var dataSourceLeft1: [String] = []
    var dataSourceLeft2: [String] = []
    var dataSourceRight: [String] = []
    
    var pickIndexLeft1: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if dataSourceLeft1.count > 0 {
            
        } else {
            filterButtonLeft1.isHidden = true
        }
        
        setupUI()
        bindUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        
        if dataSourceLeft1.count > 0 {
            filterButtonLeft1.isHidden = false
            left1DropDown.anchorView = filterButtonLeft1
            left1DropDown.setOffsetUnderView(filterButtonLeft1)
            left1DropDown.dataSource = dataSourceLeft1
            left1DropDown.selectionAction = { [weak self] (index, item) in
                self?.selectLeft1(index: index)
            }
        } else {
            filterButtonLeft1.isHidden = true
        }
        
        if dataSourceLeft2.count > 0 {
            filterButtonLeft2.isHidden = false
            left2DropDown.anchorView = filterButtonLeft2
            left2DropDown.setOffsetUnderView(filterButtonLeft2)
            left2DropDown.dataSource = dataSourceLeft2
            left2DropDown.selectionAction = { [weak self] (index, item) in
                self?.selectLeft2(index: index)
            }
        } else {
            filterButtonLeft2.isHidden = true
        }
        
        if dataSourceRight.count > 0 {
            filterButtonRight.isHidden = false
            rightDropDown.anchorView = filterButtonRight
            rightDropDown.setOffsetUnderView(filterButtonRight)
            rightDropDown.dataSource = dataSourceRight
            rightDropDown.selectionAction = { [weak self] (index, item) in
                self?.selectRight(index: index)
            }
            
        } else {
            filterButtonRight.isHidden = true
        }
        
    }
    
    func bindUI() {
        filterButtonLeft1.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.left1DropDown.show()
        }).disposed(by: disposeBag)
        
        filterButtonLeft2.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.left2DropDown.show()
        }).disposed(by: disposeBag)
        
        filterButtonRight.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.rightDropDown.show()
        }).disposed(by: disposeBag)
        
        selectedLeft1.subscribe(onNext: { [weak self] (value) in
            self?.setButtonTitle(title: value, button: self?.filterButtonLeft1)
        }).disposed(by: disposeBag)
        
        selectedLeft2.subscribe(onNext: { [weak self] (value) in
            self?.setButtonTitle(title: value, button: self?.filterButtonLeft2)
        }).disposed(by: disposeBag)
        
        selectedRight.subscribe(onNext: { [weak self] (value) in
            self?.setButtonTitle(title: value, button: self?.filterButtonRight)
        }).disposed(by: disposeBag)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChartFilterViewController {
    private func setButtonTitle(title: String?, button: UIButton?) {
        guard let button = button else {
            return
        }
        
        guard let title = title else {
            return
        }
        
        button.setTitle(title, for: .normal)
    }
    
    func selectLeft1(index: Int) {
        let value = dataSourceLeft1.tryToGetElementAt(index)
        selectedLeft1.onNext(value)
    }
    
    func selectLeft2(index: Int) {
        let value = dataSourceLeft2.tryToGetElementAt(index)
        selectedLeft2.onNext(value)
        setButtonTitle(title: value, button: filterButtonLeft2)
    }
    
    func selectRight(index: Int) {
        let value = dataSourceRight.tryToGetElementAt(index)
        selectedRight.onNext(value)
        setButtonTitle(title: value, button: filterButtonRight)
    }
    
    var filterObservable: Observable<(StockSymbol, Timeframe)> {
        let obs: Observable<(StockSymbol, Timeframe)?> = Observable.combineLatest(selectedLeft1, selectedRight)
            .map({ (symbolVal, timeframeVal) in
            guard let symbol = StockSymbol(value: symbolVal),
            let timeframe = Timeframe(value: timeframeVal) else {
                return nil
            }
            
            return (symbol, timeframe)
        })
        
        return obs.filterOutNulls()
    }
}

extension DropDown {
    func setOffsetUnderView(_ view: UIView) {
        self.bottomOffset = CGPoint(x: 0, y: view.bounds.height)
    }
}

extension Array {
    func tryToGetElementAt(_ index: Int) -> Element? {
        if index >= 0 && index < count {
            return self[index]
        } else {
            return nil
        }
    }
}

public extension Observable {
    func filterOutNulls<T>() -> Observable<T> {
        return filterMap { (obj) -> FilterMap<T> in
            guard let obj = obj as? T else {
                return .ignore
            }
            
            return .map(obj)
        }
    }
}
