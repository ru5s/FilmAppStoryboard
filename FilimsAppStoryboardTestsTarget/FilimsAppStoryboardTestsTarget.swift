//
//  FilimsAppStoryboardTestsTarget.swift
//  FilimsAppStoryboardTestsTarget
//
//  Created by Ruslan Ismailov on 02/05/23.
//

import XCTest
@testable import FilimsAppStoryboard

final class FilimsAppStoryboardTestsTarget: XCTestCase {
    
    let model = Model()
    
    var expectation: XCTestExpectation?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testURL() throws {
        
        let adress: String = "https://api.themoviedb.org/"
        
        let apiKey: String = "api_key=f4da188878dec2aea2a0e9db582199b5"
        
        let allMovie = "popular"
        
        guard let url = URL(string: "\(adress)3/movie/\(allMovie)?\(apiKey)&language=en-US&1") else {
            
            XCTFail("url not found")
            
            return
            
        }
        
        expectation = expectation(description: "api.themoviedb")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            XCTAssertNotNil(data, "the data should not be nil")
            
            XCTAssertNil(error, "data must be nil")
            
            if let httpResponse = response as? HTTPURLResponse,
               let urlResponse = httpResponse.url {
                
                XCTAssertEqual(urlResponse.absoluteString, url.absoluteString, "url from http must be equal original url")
                
                XCTAssertEqual(httpResponse.statusCode, 200, "answer status code must be equal 200")
                
            } else {
                
                XCTFail("can't get answer NSHTTPURLResponse")
                
            }
            
            self.expectation?.fulfill()
            
        }
        
        task.resume()
        
        waitForExpectations(timeout: task.originalRequest?.timeoutInterval ?? 10) {error in
            
            if let error = error {
                
                print("Error: \(error.localizedDescription)")
                
            }
            
            task.cancel()
            
        }
        
    }

    func testToggleLikeModel() throws {
        
        let testLike: Bool = true
        
        let urlService = URLService()
        
        urlService.dataRequest()
        
        if model.filmObjects?.count ?? 0 > 0 {
            
            let firstObject = model.filmObjects?.first
            
            guard let id: Int = firstObject?.id else { return XCTFail("id not be found")}
            
            if firstObject?.isLiked == false {
                
                model.toggleLike(id: id)
                
                XCTAssertEqual(firstObject?.isLiked, testLike, "something wrong with method toggle like")
                
                let methodCheck = model.checkLikeFilm(id: id)
                
                XCTAssertTrue(methodCheck, "somthing wrong with method check like film")
                
            }
            
            if firstObject?.isLiked == true {
                
                model.toggleLike(id: id)
                
                let methodCheck = model.checkLikeFilm(id: id)
                
                XCTAssertFalse(methodCheck, "somthing wrong with method check like film")
            }
            
        } else {
            
            XCTFail("Data base is empty")
            
        }
        
    }

}
