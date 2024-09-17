import XCTest
@testable import QueroSerMB

// MARK: - Mocks
class MockMainService: MainServicing {
    var mockExchanges: [Exchange] = []
    var mockLogos: [ExchangeLogo] = []
    var mockError: Error?
    
    func loadExchanges() async throws -> [Exchange] {
        if let error = mockError {
            throw error
        }
        return mockExchanges
    }
    
    func loadExchangesLogos() async throws -> [ExchangeLogo] {
        if let error = mockError {
            throw error
        }
        return mockLogos
    }
}

class MockMainPresenter: MainPresenting {
    enum Message: AutoEquatable {
        case presentExchangeList(exchanges: [Exchange], logos: [ExchangeLogo])
        case presentDetail(exchange: Exchange, logo: ExchangeLogo?)
        case presentLoading(show: Bool)
        case presentError(_ error: ServiceError)
    }

    private(set) var messages: [Message] = []
    
    func presentExchangeList(exchanges: [Exchange], logos: [ExchangeLogo]) {
        messages.append(.presentExchangeList(exchanges: exchanges, logos: logos))
    }
    
    func presentDetail(with exchange: Exchange, and logo: ExchangeLogo?) {
        messages.append(.presentDetail(exchange: exchange, logo: logo))
    }
    
    func presentLoading(with show: Bool) {
        messages.append(.presentLoading(show: show))
    }
    
    func presentError(_ error: ServiceError) {
        messages.append(.presentError(error))
    }
}

class MainInteractorTests: XCTestCase {
    func testLoad_Success() {
        let expectation = self.expectation(description: "Load exchanges and logos")
        let (sut, mockService, mockPresenter) = makeSUT()
        
        let mockExchanges = mockExchangeList()
        let mockLogos = mockExchangeLogoList()
        
        mockService.mockExchanges = mockExchanges
        mockService.mockLogos = mockLogos

        sut.load()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(mockPresenter.messages, [
                .presentLoading(show: true),
                .presentLoading(show: false),
                .presentExchangeList(exchanges: mockExchanges, logos: mockLogos),
            ])
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoad_Failure() {
        let expectation = self.expectation(description: "Load exchanges failure")
        let (sut, mockService, mockPresenter) = makeSUT()
        
        mockService.mockError = ServiceError.requestFailed(description: "Test error")
        
        sut.load()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(mockPresenter.messages, [
                .presentLoading(show: true),
                .presentLoading(show: false),
                .presentError(ServiceError.requestFailed(description: "Test error"))
            ])
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testDidTapCell_Success() {
        let expectation = self.expectation(description: "Did tap cell success")
        let (sut, mockService, mockPresenter) = makeSUT()
        let mockExchanges = mockExchangeList()
        let mockLogos = mockExchangeLogoList()
        let index = 0
        
        mockService.mockExchanges = mockExchanges
        mockService.mockLogos = mockLogos

        sut.load()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            sut.didTapCell(index: index)
            
            let logo = mockLogos.first(where: { $0.exchangeId == mockExchanges[0].exchangeId })
            
            XCTAssertEqual(mockPresenter.messages, [
                .presentLoading(show: true),
                .presentLoading(show: false),
                .presentExchangeList(exchanges: mockExchanges, logos: mockLogos),
                .presentDetail(exchange: mockExchanges[index], logo: logo)
            ])
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testDidTapCell_OutOfBounds() {
        let expectation = self.expectation(description: "Did tap cell out of bounds")
        let (sut, mockService, mockPresenter) = makeSUT()
        let mockExchanges = mockExchangeList()
        let mockLogos = mockExchangeLogoList()

        mockService.mockExchanges = mockExchanges
        mockService.mockLogos = mockLogos

        sut.load()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            sut.didTapCell(index: 1)
            
            XCTAssertEqual(mockPresenter.messages, [
                .presentLoading(show: true),
                .presentLoading(show: false),
                .presentExchangeList(exchanges: mockExchanges, logos: mockLogos),
                .presentError(ServiceError.outOfBounds)
            ])
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: MainInteractor, service: MockMainService, presenter: MockMainPresenter) {
        let mockService = MockMainService()
        let mockPresenter = MockMainPresenter()
        let sut = MainInteractor(service: mockService, presenter: mockPresenter)
        
        trackForMemoryLeaks(mockService, file: file, line: line)
        trackForMemoryLeaks(mockPresenter, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, mockService, mockPresenter)
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
