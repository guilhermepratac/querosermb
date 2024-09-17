import XCTest
@testable import QueroSerMB

// MARK: - Mocks
class MockDetailService: DetailServicing {
    var mockOHLCVData: [OHLCVData] = []
    var mockError: Error?
    
    func getOhlcv(spot: String, timeStart: String, timeEnd: String, _ completion: @escaping (DetailServicing.ExchangeDetailResult) -> Void) {
        if let error = mockError {
            completion(.failure(error as! ServiceError))
        } else {
            completion(.success(mockOHLCVData))
        }
    }
}

class MockDetailPresenter: DetailPresenting {
    enum Message: AutoEquatable {
        case displayDetail(model: ExchangeDetail)
        case displayChart(data: [OHLCVData])
        case presentErrorChart(error: ServiceError)
        case displayLoading(show: Bool)
    }

    private(set) var messages: [Message] = []
    
    func displayDetail(with model: ExchangeDetail) {
        messages.append(.displayDetail(model: model))
    }
    
    func displayChart(with data: [OHLCVData]) {
        messages.append(.displayChart(data: data))
    }
    
    func presentErrorChart(with error: ServiceError) {
        messages.append(.presentErrorChart(error: error))
    }
    
    func displayLoading(with show: Bool) {
        messages.append(.displayLoading(show: show))
    }
}

class DetailInteractorTests: XCTestCase {
    func testLoad_Success() {
        let expectation = self.expectation(description: "Load exchange detail and chart")
        let (sut, mockService, mockPresenter) = makeSUT()
        
        let mockExchangeDetail = mockExchangeDetail()
        let mockOHLCVData = mockOHLCVDataList()
        
        mockService.mockOHLCVData = mockOHLCVData

        sut.load()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(mockPresenter.messages, [
                .displayDetail(model: mockExchangeDetail),
                .displayLoading(show: true),
                .displayLoading(show: false),
                .displayChart(data: mockOHLCVData)
            ])
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoad_Failure() {
        let expectation = self.expectation(description: "Load exchange detail failure")
        let (sut, mockService, mockPresenter) = makeSUT()
        
        mockService.mockError = ServiceError.requestFailed(description: "Test error")
        
        sut.load()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(mockPresenter.messages, [
                .displayDetail(model: self.mockExchangeDetail()),
                .displayLoading(show: true),
                .displayLoading(show: false),
                .presentErrorChart(error: ServiceError.requestFailed(description: "Test error"))
            ])
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: DetailInteractor, service: MockDetailService, presenter: MockDetailPresenter) {
        let mockService = MockDetailService()
        let mockPresenter = MockDetailPresenter()
        let mockExchangeDetail = mockExchangeDetail()
        let sut = DetailInteractor(service: mockService, presenter: mockPresenter, exchange: mockExchangeDetail)
        
        trackForMemoryLeaks(mockService, file: file, line: line)
        trackForMemoryLeaks(mockPresenter, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, mockService, mockPresenter)
    }
    
    private func mockExchangeDetail() -> ExchangeDetail {
        ExchangeDetail(
            urlImage: "https://test.com/logo.png",
            name: "Test Exchange",
            exchangeId: "TEST",
            hourVolumeUsd: "100",
            dailyVolumeUsd: "1000",
            monthVolumeUsd: "10000"
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
