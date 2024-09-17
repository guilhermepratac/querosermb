import XCTest
@testable import QueroSerMB

class MockDetailCoordinator: DetailCoordinating {
    var openSomethingCalled = false
    
    func openSomething() {
        openSomethingCalled = true
    }
}

class MockDetailViewController: DetailDisplaying {
    enum Message: AutoEquatable {
        case displayDetail(model: ExchangeInformationModel)
        case displayChart(data: [(Date, Double)])
        case displayChartError(title: String, message: String, button: String?)
        case displayLoading
        case dismissLoading
    }
    
    private(set) var messages: [Message] = []
    
    func displayDetail(with model: ExchangeInformationModel) {
        messages.append(.displayDetail(model: model))
    }
    
    func displayChart(data: [(Date, Double)]) {
        messages.append(.displayChart(data: data))
    }
    
    func displayChartError(title: String, message: String, button: String?) {
        messages.append(.displayChartError(title: title, message: message, button: button))
    }
    
    func displayLoading() {
        messages.append(.displayLoading)
    }
    
    func dismissLoading() {
        messages.append(.dismissLoading)
    }
}

class DetailPresenterTests: XCTestCase {
    func testDisplayDetail() {
        let expectation = self.expectation(description: "Display detail")
        let (sut, _, mockViewController) = makeSUT()
        
        let mockExchangeDetail = mockExchangeDetail()
        
        sut.displayDetail(with: mockExchangeDetail)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(mockViewController.messages.count, 1)
            if case .displayDetail(let model) = mockViewController.messages[0] {
                XCTAssertEqual(model.urlImage, "https://test.com/logo.png")
                XCTAssertEqual(model.name, "Test Exchange")
                XCTAssertEqual(model.exchangeId, "ID: TEST")
                XCTAssertEqual(model.hourVolume,"Volume de última hora: 100")
                XCTAssertEqual(model.dailyVolume,"Volume de último dia: 100")
                XCTAssertEqual(model.monthVolume, "Volume de último mês: 10,000")
            } else {
                XCTFail("Expected displayDetail message")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testDisplayChart() {
        let expectation = self.expectation(description: "Display chart")
        let (sut, _, mockViewController) = makeSUT()
        
        let mockOHLCVData = mockOHLCVDataList()
        
        sut.displayChart(with: mockOHLCVData)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(mockViewController.messages.count, 1)
            if case .displayChart(let data) = mockViewController.messages[0] {
                XCTAssertEqual(data.count, 1)
                XCTAssertEqual(data[0].1, 1000.0)
            } else {
                XCTFail("Expected displayChart message")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testPresentErrorChart() {
        let expectation = self.expectation(description: "Present error chart")
        let (sut, _, mockViewController) = makeSUT()
        
        let error = ServiceError.requestFailed(description: "Test error")
        sut.presentErrorChart(with: error)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(mockViewController.messages.count, 1)
            if case .displayChartError(let title, let message, let button) = mockViewController.messages[0] {
                XCTAssertEqual(title, "Houve um problema")
                XCTAssertEqual(message, "Erro na requisição: Test error")
                XCTAssertEqual(button, "Tente novamente")
            } else {
                XCTFail("Expected displayChartError message")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testDisplayLoading() {
        let expectation = self.expectation(description: "Display loading")
        let (sut, _, mockViewController) = makeSUT()
        
        sut.displayLoading(with: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(mockViewController.messages, [.displayLoading])
            
            sut.displayLoading(with: false)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(mockViewController.messages, [.displayLoading, .dismissLoading])
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: DetailPresenter, coordinator: MockDetailCoordinator, viewController: MockDetailViewController) {
        let mockCoordinator = MockDetailCoordinator()
        let mockViewController = MockDetailViewController()
        let sut = DetailPresenter(coordinator: mockCoordinator)
        sut.viewController = mockViewController
        
        trackForMemoryLeaks(mockCoordinator, file: file, line: line)
        trackForMemoryLeaks(mockViewController, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, mockCoordinator, mockViewController)
    }
    
    private func mockExchangeDetail() -> ExchangeDetail {
        ExchangeDetail(
            urlImage: "https://test.com/logo.png",
            name: "Test Exchange",
            exchangeId: "TEST",
            hourVolumeUsd: "100",
            dailyVolumeUsd: "1,000",
            monthVolumeUsd: "10,000"
        )
    }
    
    private func mockOHLCVDataList() -> [OHLCVData] {
        [
            OHLCVData(
                timePeriodStart: "2023-01-01T00:00:00Z",
                timePeriodEnd: "2023-01-01T01:00:00Z",
                timeOpen: "2023-01-01T00:00:00Z",
                timeClose: "2023-01-01T01:00:00Z",
                priceOpen: 100.0,
                priceHigh: 110.0,
                priceLow: 90.0,
                priceClose: 105.0,
                volumeTraded: 1000.0,
                tradesCount: 100
            )
        ]
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
