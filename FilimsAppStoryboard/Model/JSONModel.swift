//
//  JSONModel.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/02/23.
//

import Foundation

class MovieList: Codable {
    var page: Int?
    var results: [Result]?
    var totalPages: Int?
    var totalResults: Int?
    
    enum codingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

class Result: Codable {
    var id: Int?
    var original_title: String?
    var poster_path: String?
    var release_date: String?
    var overview: String?
    var vote_average: Double?
    var backdrop_path: String?
//    var screenshots: [ScreensLink]
}

class AllScreens: Codable {
    var backdrops: [ScreensLink]
}

class ScreensLink: Codable {
    var aspect_ratio: Double?
    var height: Int
    var file_path: String?
    var width: Int
}

class TestModel {
    var testPic: String?
    var testTitle: String?
    var testYear: String?
    var testRating: String?
    
    init(testPic: String? = nil, testTitle: String? = nil, testYear: String? = nil, testRating: String? = nil) {
        self.testPic = testPic
        self.testTitle = testTitle
        self.testYear = testYear
        self.testRating = testRating
    }
}

