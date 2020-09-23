//
//  ChartFilterVcTests.swift
//  StockAPITests
//
//  Created by Voro on 23.09.20.
//

import XCTest
import RxSwift

@testable import StockAPI


class ChartFilterVcTests: XCTestCase {
    let disposeBag = DisposeBag()
    let container = AppDelegate.container
    
    func createChartFilterVC(filterLeft1Data: [String], filterRightData: [String]) -> ChartFilterViewController {
        let vc = Storyboard.main.instantiate(ChartFilterViewController.self)
        vc.dataSourceLeft1 = filterLeft1Data
        vc.dataSourceRight = filterRightData
        vc.loadViewIfNeeded()
        return vc
    }
    
    func testInitialValues() throws {
        let vc = createChartFilterVC(filterLeft1Data: StockSymbol.allCases.map { $0.rawValue },
                                     filterRightData: Timeframe.allCases.map { $0.rawValue })
        
        vc.selectLeft1(index: 2)
        vc.selectRight(index: 1)
        
        vc.filterObservable.subscribe(onNext: { (symbol, timeframe) in
            XCTAssert(symbol == .apple)
            XCTAssert(timeframe == .weekly)
        }, onError: { (error) in
            XCTFail("Unexpected error: \(error)")
        }, onCompleted: {
            XCTFail("Unexpected complete of observable sequence")
        }).disposed(by: disposeBag)
    }
    
    func testValuesChange() throws {
        let vc = createChartFilterVC(filterLeft1Data: StockSymbol.allCases.map { $0.rawValue },
                                     filterRightData: Timeframe.allCases.map { $0.rawValue })
        
        vc.selectLeft1(index: 2)
        vc.selectRight(index: 1)
        
        var expectedSequence: [(StockSymbol, Timeframe)] = [
            (.apple, .weekly),
            (.ibm, .weekly),
            (.ibm, .daily)
        ]
        
        vc.filterObservable.subscribe(onNext: { (symbol, timeframe) in
            if expectedSequence.popIfContains((symbol, timeframe)) == false {
                XCTFail("Unexpected filter combination \(symbol) \(timeframe)")
            }
        }, onError: { (error) in
            XCTFail("Unexpected error: \(error)")
        }, onCompleted: {
            XCTFail("Unexpected complete of observable sequence")
        }).disposed(by: disposeBag)
        
        vc.selectLeft1(index: 0)
        vc.selectRight(index: 0)
        
        XCTAssert(expectedSequence.count == 0)
    }
}


extension Array where Element == (StockSymbol, Timeframe) {
    mutating func popIfContains(_ value: (StockSymbol, Timeframe)) -> Bool {
        let first = self[0]
        if first.0 == value.0 && first.1 == value.1 {
            self.remove(at: 0)
            return true
        } else {
            return false
        }
    }
}
