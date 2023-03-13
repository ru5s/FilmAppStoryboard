//
//  JSONModel.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/02/23.
//

import Foundation

class JSONModel: Codable {
    var original_title: String?
    var poster_path: String?
    var release_date: String?
    var overview: String?
    var vote_average: Double?
    var backdrop_path: String?
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


//var testArray: [TestModel] = [
//    TestModel(testPic: "1", testTitle: "Доктор сон", testYear: "2000", testRating: "7.8"),
//    TestModel(testPic: "2", testTitle: "1408", testYear: "1999", testRating: "8.0"),
//    TestModel(testPic: "3", testTitle: "Долорес Клейборн", testYear: "1991", testRating: "6.7"),
//    TestModel(testPic: "4", testTitle: "Кладбище домашних животных", testYear: "2001", testRating: "8.2"),
//    TestModel(testPic: "5", testTitle: "Дети кукурузы", testYear: "1996", testRating: "7.9"),
//    TestModel(testPic: "6", testTitle: "Мизери", testYear: "1989", testRating: "7.3"),
//    TestModel(testPic: "1", testTitle: "Доктор сон", testYear: "2000", testRating: "7.8"),
//    TestModel(testPic: "2", testTitle: "1408", testYear: "1999", testRating: "8.0"),
//    TestModel(testPic: "3", testTitle: "Долорес Клейборн", testYear: "1991", testRating: "6.7"),
//    TestModel(testPic: "4", testTitle: "Кладбище домашних животных", testYear: "2001", testRating: "8.2"),
//    TestModel(testPic: "5", testTitle: "Дети кукурузы", testYear: "1996", testRating: "7.9"),
//    TestModel(testPic: "6", testTitle: "Мизери", testYear: "1989", testRating: "7.3"),
//]
