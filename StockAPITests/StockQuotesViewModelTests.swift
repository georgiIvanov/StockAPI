//
//  StockQuotesViewModelTests.swift
//  StockAPITests
//
//  Created by Voro on 23.09.20.
//

import XCTest
import RxSwift

@testable import StockAPI

class StockQuotesViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    let container = AppDelegate.container
    
    func testGetIBMDailyStocks() throws {
        let expectation = self.expectation(description: "Get daily IBM stocks data.")
        
        let vm = container.resolve(StockQuotesViewModelProtocol.self)!
        vm.fetchQuotes(symbol: .ibm, timeframe: .daily).subscribe(onSuccess: { (quotes) in
            XCTAssert(quotes.count > 0)
            expectation.fulfill()
        }, onError: { (error) in
            XCTFail("Unexpected error: \(error)")
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testGetMSFTMonthlyStocks() throws {
        let expectation = self.expectation(description: "Get monthly MSFT stocks data.")
        
        let vm = container.resolve(StockQuotesViewModelProtocol.self)!
        vm.fetchQuotes(symbol: .microsoft, timeframe: .monthly).subscribe(onSuccess: { (quotes) in
            XCTAssert(quotes.count > 0)
            expectation.fulfill()
        }, onError: { (error) in
            XCTFail("Unexpected error: \(error)")
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testStocksFromIBMAndMSFT() throws {
        let expectationMSFT = self.expectation(description: "Get weekly MSFT stocks data.")
        let expectationIBM = self.expectation(description: "Get weekly IBM stocks data.")
        
        let vm = container.resolve(StockQuotesViewModelProtocol.self)!
        
        vm.fetchQuotes(symbol: .microsoft, timeframe: .weekly).subscribe(onSuccess: { (quotes) in
            XCTAssert(quotes.count > 0)
            expectationMSFT.fulfill()
        }, onError: { (error) in
            XCTFail("Unexpected error: \(error)")
        }).disposed(by: disposeBag)
        
        vm.fetchQuotes(symbol: .ibm, timeframe: .weekly).subscribe(onSuccess: { (quotes) in
            XCTAssert(quotes.count > 0)
            expectationIBM.fulfill()
        }, onError: { (error) in
            XCTFail("Unexpected error: \(error)")
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}
