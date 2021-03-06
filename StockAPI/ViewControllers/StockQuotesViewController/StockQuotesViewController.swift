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
    @IBOutlet weak var selectedCandleLabel: UILabel!
    
    let disposeBag = DisposeBag()
    let xAxisFormatter = ChartXAxisFormatter()
    var viewModel: StockQuotesViewModelProtocol!
    var filterVc: ChartFilterViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func fetchQuotes(symbol: StockSymbol, timeframe: Timeframe) {
        viewModel.fetchQuotes(symbol: symbol, timeframe: timeframe).subscribe(onSuccess: { [weak self] (quotes) in
            self?.xAxisFormatter.setQuotes(quotes, timeframe: timeframe)
            self?.reloadCandleData(quotes)
        }, onError: { [weak self] (error) in
            self?.presentAlertMessage(title: "An error occurred while fetching quotes.",
                                      message: error.localizedDescription)
            print("Error: \(error)")
        }).disposed(by: disposeBag)
    }
    
    func setupUI() {
        setupChart()
        filterVc.selectLeft1(index: 0)
        filterVc.selectRight(index: 0)
        updateSelectedCandleLabel(nil)
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
        chartView.xAxis.valueFormatter = xAxisFormatter
    }
    
    func bindUI() {
        filterVc.filterObservable.subscribe(onNext: { [weak self] (symbol, timeframe) in
            self?.fetchQuotes(symbol: symbol, timeframe: timeframe)
        }).disposed(by: disposeBag)
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
    
    func updateSelectedCandleLabel(_ text: String?) {
        guard let text = text else {
            selectedCandleLabel.isHidden = true
            return
        }
        
        selectedCandleLabel.isHidden = false
        selectedCandleLabel.text = text
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let filterVc = segue.destination as? ChartFilterViewController {
            filterVc.dataSourceLeft1 = StockSymbol.allCases.map { $0.rawValue }
            filterVc.dataSourceRight = Timeframe.allCases.map { $0.rawValue }
            self.filterVc = filterVc
        }
    }
}

extension StockQuotesViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let entry = entry as? CandleChartDataEntry else {
            return
        }
        
        updateSelectedCandleLabel(" O: \(entry.open) H: \(entry.high) L: \(entry.low) C: \(entry.close)  ")
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        updateSelectedCandleLabel(nil)
    }
    
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        print("did end panning")
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        print("chart scaled")
    }
    
    func chartTranslated(_ chartView: ChartViewBase, deltaX: CGFloat, deltaY: CGFloat) {
        
    }
    
    func chartView(_ chartView: ChartViewBase, animatorDidStop animator: Animator) {
        print("animator did stop")
    }
}

extension UIViewController {
    func presentAlertMessage(title: String, message: String?) {
        let alertVc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVc.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertVc, animated: true, completion: nil)
    }
}
