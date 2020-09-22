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

class ChartFilterViewController: UIViewController {
    
    @IBOutlet weak var filterButtonLeft1: UIButton!
    @IBOutlet weak var filterButtonLeft2: UIButton!
    @IBOutlet weak var filterButtonRight: UIButton!
    
    let disposeBag = DisposeBag()
    let left1DropDown = DropDown()
    let left2DropDown = DropDown()
    let rightDropDown = DropDown()
    
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


extension DropDown {
    func setOffsetUnderView(_ view: UIView) {
        self.bottomOffset = CGPoint(x: 0, y: view.bounds.height)
    }
}
