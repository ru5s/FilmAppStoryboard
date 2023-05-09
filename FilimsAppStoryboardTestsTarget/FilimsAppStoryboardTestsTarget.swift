//
//  FilimsAppStoryboardTestsTarget.swift
//  FilimsAppStoryboardTestsTarget
//
//  Created by Ruslan Ismailov on 02/05/23.
//

import XCTest
@testable import FilimsAppStoryboard
@testable import Pods_FilimsAppStoryboard

final class FilimsAppStoryboardTestsTarget: XCTestCase {
    
    let model = Model()
    
    let urlService = URLService()
    
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
            
            let firstObject = FilmObject()
            firstObject.id = 1
            firstObject.isLiked = false
            
            model.addTestObjectToDataBaseSpecial(firstObject)
            
            let item = model.firstObjectByID(firstObject.id)
            
            guard let id: Int = item?.id else { return XCTFail("id not be found")}
            
            if item?.isLiked == false {
                
                model.toggleLike(id: id)
                
                let likedItem = model.firstObjectByID(id)
                
                XCTAssertEqual(likedItem?.isLiked, testLike, "something wrong with method toggle like")
                
                guard let likedId: Int = likedItem?.id else { return XCTFail("id not be found")}
                
                let methodCheck = model.checkLikeFilm(id: likedId)
                
                XCTAssertTrue(methodCheck, "somthing wrong with method check like film")
                
            }
            
            if item?.isLiked == true {
                
                model.toggleLike(id: id)
                
                let methodCheck = model.checkLikeFilm(id: id)
                
                XCTAssertFalse(methodCheck, "somthing wrong with method check like film")
                
            }

            model.removeTestObjectFromDataBaseSpecial(firstObject)
            
        }

}
