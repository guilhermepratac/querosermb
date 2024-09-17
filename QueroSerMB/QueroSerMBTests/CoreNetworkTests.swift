import XCTest
@testable import QueroSerMB

class MockURLSession: URLSession {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    override class var shared: URLSession {
        return MockURLSession()
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockURLSessionDataTask { [weak self] in
            guard let self = self else { return }
            completionHandler(self.mockData, self.mockResponse, self.mockError)
        }
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
        super.init()
    }
    
    override func resume() {
        closure()
    }
}

class CoreNetworkTests: XCTestCase {
    func testGet_Success() {
        let expectation = self.expectation(description: "Successful GET request")
        let (sut, mockURLSession) = makeSUT()
        
        let mockExchange = Exchange(name: "Test Exchange", exchangeId: "TEST", dailyVolumeUsd: 1000, hourVolumeUsd: 100, monthVolumeUsd: 10000)
        let mockData = try! JSONEncoder().encode([mockExchange])
        mockURLSession.mockData = mockData
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let request = URLRequest(url: URL(string: "https://test.com")!)
        
        sut.get(request: request, of: [Exchange].self) { result in
            switch result {
            case .success(let exchanges):
                XCTAssertEqual(exchanges, [mockExchange])
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testGet_Failure_NetworkError() {
        let expectation = self.expectation(description: "Failed GET request - Network Error")
        let (sut, mockURLSession) = makeSUT()
        
        mockURLSession.mockError = NSError(domain: "NetworkError", code: -1, userInfo: nil)
        
        let request = URLRequest(url: URL(string: "https://test.com")!)
        
        sut.get(request: request, of: [Exchange].self) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertEqual(error, .requestFailed(description: "The operation couldn’t be completed. (NetworkError error -1.)"))
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testGet_Failure_EmptyData() {
        let expectation = self.expectation(description: "Failed GET request - Empty Data")
        let (sut, mockURLSession) = makeSUT()
        
        mockURLSession.mockData = Data()
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let request = URLRequest(url: URL(string: "https://test.com")!)
        
        sut.get(request: request, of: [Exchange].self) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertEqual(error, .emptyData)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testGet_Failure_DecodeError() {
        let expectation = self.expectation(description: "Failed GET request - Decode Error")
        let (sut, mockURLSession) = makeSUT()
        
        let invalidData = "Invalid JSON".data(using: .utf8)!
        mockURLSession.mockData = invalidData
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let request = URLRequest(url: URL(string: "https://test.com")!)
        
        sut.get(request: request, of: [Exchange].self) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertEqual(error, .decodeError)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: CoreNetwork, session: MockURLSession) {
        let mockURLSession = MockURLSession()
        let sut = CoreNetwork(session: mockURLSession)
        
        trackForMemoryLeaks(mockURLSession, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, mockURLSession)
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
