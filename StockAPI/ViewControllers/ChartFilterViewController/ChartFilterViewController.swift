//
//  ChartFilterViewController.swift
//  StockAPI
//
//  Created by Voro on 20.09.20.
//

import UIKit

class ChartFilterViewController: UIViewController {
    
    @IBOutlet weak var filterButtonLeft1: UIButton!
    @IBOutlet weak var filterButtonLeft2: UIButton!
    @IBOutlet weak var filterButtonRight: UIButton!
    
    var dataSourceLeft1: [String] = []
    var dataSourceLeft2: [String] = []
    var dataSourceRight: [String] = []
    
    var pickIndexLeft1: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if dataSourceLeft1.count > 0 {
            
        } else {
            filterButtonLeft1.isHidden = true
        }
        
        // Do any additional setup after loading the view.
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
