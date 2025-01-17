//
//  FlickrSearchViewModelTests.swift
//  FlickrGalleryTests
//
//  Created by Lorenzo on 1/17/25.
//

import Combine
import Foundation
import XCTest
@testable import FlickrGallery

class FlickrSearchViewModelTests: XCTestCase {
    private var cancellabes = Set<AnyCancellable>()
    private var viewModel: FlickrSearchViewModel!
    
    override func setUp() async throws {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: sessionConfiguration)
        
        let flickrClient = FlickrService(session: session)
        viewModel = await FlickrSearchViewModel(flickrService: flickrClient)
    }
    
    override func tearDown() async throws {
        
    }
    
    func testFetchItems_Success() async throws {
        MockURLProtocol.setSuccessHandler()

        let items = try await viewModel.flickrService.fetchFlickrFeed(for: "dogs")
                
        XCTAssert(items.count == 3)

        let item1 = items[0]
        let item2 = items[1]
        let item3 = items[2]
        
        XCTAssert(item1.title == "Title numbner 1")
        XCTAssert(item1.link == "https://www.anywebsite.com/id/001")
        XCTAssert(item1.media.m == "https://www.anywebsite.com/id/001")
        XCTAssert(item1.dateTaken == "2025-01-17T06:56:57-08:00")
        XCTAssert(item1.description == "simple description number 1")
        XCTAssert(item1.published == "2025-01-17T12:05:40Z")
        XCTAssert(item1.author == "Someone, someone1@gmail.com")
        XCTAssert(item1.tags == "random tags")
        
        XCTAssert(item2.title == "Title numbner 2")
        XCTAssert(item2.link == "https://www.anywebsite.com/id/002")
        XCTAssert(item2.media.m == "https://www.anywebsite.com/id/002")
        XCTAssert(item2.dateTaken == "2025-01-17T06:56:57-08:00")
        XCTAssert(item2.description == "simple description number 2")
        XCTAssert(item2.published == "2025-01-17T12:05:40Z")
        XCTAssert(item2.author == "Someone, someone2@gmail.com")
        XCTAssert(item2.tags == "random tags")
        
        XCTAssert(item3.title == "Title numbner 3")
        XCTAssert(item3.link == "https://www.anywebsite.com/id/003")
        XCTAssert(item3.media.m == "https://www.anywebsite.com/id/003")
        XCTAssert(item3.dateTaken == "2025-01-17T06:56:57-08:00")
        XCTAssert(item3.description == "simple description number 3")
        XCTAssert(item3.published == "2025-01-17T12:05:40Z")
        XCTAssert(item3.author == "Someone, someone3@gmail.com")
        XCTAssert(item3.tags == "random tags")        
    }
    
    func testFetchItems_EmptyData() async throws {
        MockURLProtocol.setEmptyDataHandler()
        
        let items = try await viewModel.flickrService.fetchFlickrFeed(for: "dogs")

        XCTAssert(items.isEmpty)
    }
    
    func testFetchItems_MalformedData() async throws {
        MockURLProtocol.setMalformedDataHandler()
        
        let throwsErrorExpectation = XCTestExpectation(description: "Fetching malformed data should throw error")
        
        do {
            let _ = try await viewModel.flickrService.fetchFlickrFeed(for: "dogs")
        } catch {
            throwsErrorExpectation.fulfill()
        }

        await fulfillment(of: [throwsErrorExpectation], timeout: 1)
    }
}
