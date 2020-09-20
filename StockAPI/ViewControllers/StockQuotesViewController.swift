//
//  StockQuotesViewController.swift
//  StockAPI
//
//  Created by Voro on 19.09.20.
//

import Foundation
import UIKit
import RxSwift
import Charts

class StockQuotesViewController: UIViewController {
    
    @IBOutlet weak var chartView: CandleStickChartView!
    
    let disposeBag = DisposeBag()
    var viewModel: StockQuotesViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChart()
        
        viewModel.fetchDailyQuotes(symbol: .microsoft).subscribe { [weak self] (quotes) in
            self?.reloadCandleData(quotes)
        } onError: { (err) in
            print(err)
        }.disposed(by: disposeBag)

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupChart() {
        chartView.delegate = self
        chartView.chartDescription?.enabled = false
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        chartView.legend.enabled = false
        
        chartView.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        chartView.leftAxis.spaceTop = 0.3
        chartView.leftAxis.spaceBottom = 0.3
        chartView.leftAxis.axisMinimum = 0
        
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
    }
    
    func reloadCandleData(_ quotes: [Quote]) {
        
        var highest: Double = 0
        var lowest: Double = Double.greatestFiniteMagnitude
        
        print("Fetched quotes count: \(quotes.count)")
        let entries = (0..<quotes.count).map { (i) -> CandleChartDataEntry in
            let high = Double(quotes[i].high)!
            let low = Double(quotes[i].low)!
            let open = Double(quotes[i].open)!
            let close = Double(quotes[i].close)!
            highest = max(highest, high)
            lowest = min(lowest, low)
            
            return CandleChartDataEntry(x: Double(i),
                                        shadowH: high,
                                        shadowL: low,
                                        open: open,
                                        close: close,
                                        icon: nil)
        }
        
        let set1 = CandleChartDataSet(entries: entries, label: nil)
        set1.axisDependency = .left
        set1.setColor(UIColor(white: 80/255, alpha: 1))
        set1.drawIconsEnabled = false
        set1.shadowColor = .darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = .red
        set1.decreasingFilled = true
        set1.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
        set1.increasingFilled = false
        
        let data = CandleChartData(dataSet: set1)
        chartView.data = data
        chartView.setVisibleXRange(minXRange: 3, maxXRange: 20)
        
        let axisInsetPercentage = 0.02
        chartView.leftAxis.axisMinimum = lowest - (lowest * axisInsetPercentage)
        chartView.leftAxis.axisMaximum = highest + (highest * axisInsetPercentage)
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

extension StockQuotesViewController: ChartViewDelegate {
    
}
