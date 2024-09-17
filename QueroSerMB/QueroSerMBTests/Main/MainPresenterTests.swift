import XCTest
@testable import QueroSerMB

// MARK: - Mocks
class MockMainCoordinator: MainCoordinating {
    var openExchangeDetailCalled = false
    var lastOpenedExchange: ExchangeDetail?
    
    func openExchangeDetail(with exchange: ExchangeDetail) {
        openExchangeDetailCalled = true
        lastOpenedExchange = exchange
    }
}

class MockMainViewController: MainDisplaying {
    enum Message: AutoEquatable {
        case displayExchanges(exchanges: [ExchangeCellModel])
        case showError(error: ServiceError)
        case showLoading
        case hideLoading
    }

    private(set) var messages: [Message] = []
    
    func displayExchanges(exchanges: [ExchangeCellModel]) {
        messages.append(.displayExchanges(exchanges: exchanges))
    }
    
    func showError(_ error: ServiceError) {
        messages.append(.showError(error: error))
    }
    
    func showLoading() {
        messages.append(.showLoading)
    }
    
    func hideLoading() {
        messages.append(.hideLoading)
    }
}

class MainPresenterTests: XCTestCase {
    func testPresentExchangeList() {
        let expectation = self.expectation(description: "Present exchange list")
        let (sut, mockCoordinator, mockViewController) = makeSUT()
        
        let mockExchanges = mockExchangeList()
        let mockLogos = mockExchangeLogoList()
        
        sut.presentExchangeList(exchanges: mockExchanges, logos: mockLogos)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(mockViewController.messages, [
                .displayExchanges(exchanges: [
                    ExchangeCellModel(
                        icon: "https://test.com/logo.png",
                        name: "Test Exchange",
                        exchange: "TEST",
                        price: "$ 1.000,00"
                    )
                ])
            ])
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testPresentDetail() {
        let expectation = self.expectation(description: "Present exchange detail")
        let (sut, mockCoordinator, _) = makeSUT()
        
        let mockExchange = mockExchangeList()[0]
        let mockLogo = mockExchangeLogoList()[0]
        
        sut.presentDetail(with: mockExchange, and: mockLogo)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(mockCoordinator.openExchangeDetailCalled)
            XCTAssertEqual(mockCoordinator.lastOpenedExchange?.name, "Test Exchange")
            XCTAssertEqual(mockCoordinator.lastOpenedExchange?.exchangeId, "TEST")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testPresentLoading() {
        let expectation = self.expectation(description: "Present loading")
        let (sut, _, mockViewController) = makeSUT()
        
        sut.presentLoading(with: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(mockViewController.messages, [.showLoading])
            
            sut.presentLoading(with: false)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(mockViewController.messages, [.showLoading, .hideLoading])
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testPresentError() {
        let expectation = self.expectation(description: "Present error")
        let (sut, _, mockViewController) = makeSUT()
        
        let error = ServiceError.requestFailed(description: "Test error")
        sut.presentError(error)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(mockViewController.messages, [.showError(error: error)])
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: MainPresenter, coordinator: MockMainCoordinator, viewController: MockMainViewController) {
        let mockCoordinator = MockMainCoordinator()
        let mockViewController = MockMainViewController()
        let sut = MainPresenter(coordinator: mockCoordinator)
        sut.viewController = mockViewController
        
        trackForMemoryLeaks(mockCoordinator, file: file, line: line)
        trackForMemoryLeaks(mockViewController, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, mockCoordinator, mockViewController)
    }
    
    private func mockExchangeList() -> [Exchange] {
        [
            Exchange(name: "Test Exchange", exchangeId: "TEST", dailyVolumeUsd: 1000, hourVolumeUsd: 100, monthVolumeUsd: 10000)
        ]
    }
    
    private func mockExchangeLogoList() -> [ExchangeLogo] {
        [
            ExchangeLogo(exchangeId: "TEST", url: "https://test.com/logo.png")
        ]
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
