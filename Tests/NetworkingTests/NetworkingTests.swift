//
//  Created by Amir Daliri on 10.01.2024.
//

import XCTest
import Combine
import Alamofire
@testable import Networking

class NetworkingTests: XCTestCase {
    
    let mockResponseData = """
        {
            "resultObject": {
                "exampleKey": "exampleValue"
            },
            "resultStatus": true
        }
    """.data(using: .utf8)!
    
    func testFetchSuccess() {
        let mockSession = MockSessionProtocol()
        let apiRequest = ApiRequest(session: mockSession)
        
        let url = URL(string: "https://example.com")!
        
        // Convert HTTPHeaders to [String: String] for headerFields
        let headers: HTTPHeaders = [
            "Authorization": "Bearer token"
        ]
        
        // Set up the mock response
        mockSession.data = mockResponseData
        mockSession.response = AFDataResponse<Data>(
            request: URLRequest(url: url),
            response: HTTPURLResponse.init(),
            data: mockResponseData,
            metrics: nil,
            serializationDuration: 1.0,
            result: .success(mockResponseData)
        )
        
        let expectation = XCTestExpectation(description: "Fetch should complete successfully")
        
        
        let cancellable = apiRequest.fetch(url, .get, nil, headers)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break // Test passed
                case .failure(let error):
                    XCTFail("Fetch failed with error: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { data in
                XCTAssertNotNil(data)
            })
        
        wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
}
