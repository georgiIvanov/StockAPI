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
        
        viewModel.fetchDailyQuotes(symbol: .microsoft).subscribe(onSuccess: { [weak self] (quotes) in
            self?.reloadCandleData(quotes)
        }, onError: { (err) in
            print(err)
        }).disposed(by: disposeBag)

        
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
        
        chartView.rightAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        chartView.rightAxis.labelTextColor = .white
        chartView.rightAxis.spaceTop = 0.1
        chartView.rightAxis.spaceBottom = 0.1
        
        chartView.leftAxis.enabled = false
        
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
    }
    
    func reloadCandleData(_ quotes: [Quote]) {
        
        var highest: Double = 0
        var lowest: Double = Double.greatestFiniteMagnitude
        
        print("Fetched quotes count: \(quotes.count)")
        let entries = (0..<quotes.count).map { (index) -> CandleChartDataEntry in
            let high = Double(quotes[index].high)!
            let low = Double(quotes[index].low)!
            let open = Double(quotes[index].open)!
            let close = Double(quotes[index].close)!
            highest = max(highest, high)
            lowest = min(lowest, low)
            
            return CandleChartDataEntry(x: Double(index),
                                        shadowH: high,
                                        shadowL: low,
                                        open: open,
                                        close: close,
                                        icon: nil)
        }
        
        let dataSet = CandleChartDataSet(entries: entries, label: nil)
        dataSet.axisDependency = .right
        dataSet.setColor(UIColor(white: 80/255, alpha: 1))
        dataSet.drawIconsEnabled = false
        dataSet.shadowColor = UIColor(white: 1, alpha: 0.7)
        dataSet.shadowWidth = 0.7
        dataSet.decreasingColor = .red
        dataSet.decreasingFilled = true
        dataSet.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
        dataSet.increasingFilled = false
        dataSet.valueTextColor = .white
        
        let chartData = CandleChartData(dataSet: dataSet)
        chartView.data = chartData
        chartView.setVisibleXRange(minXRange: 3, maxXRange: 20)
        
        chartView.moveViewToX(Double(quotes.count))
        chartView.autoScaleMinMaxEnabled = true
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
