//
//  Model.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/03/23.
//

import Foundation



class Item {
    
    var id: Int?
    var testPic: String?
    var testTitle: String?
    var testYear: Int?
    var testRating: Double?
    var isLiked: Bool
    
    init (id: Int?, testPic: String?, testTitle: String?, testYear: Int?, testRating: Double?, isLiked: Bool) {
        self.id = id
        self.testPic = testPic
        self.testTitle = testTitle
        self.testYear = testYear
        self.testRating = testRating
        self.isLiked = isLiked
    }
}

class Model {
    var testArray: [Item] = [
        .init(id: 0, testPic: "1", testTitle: "Доктор сон", testYear: 2000, testRating: 7.8, isLiked: false),
        .init(id: 1, testPic: "2", testTitle: "1408", testYear: 1987, testRating: 9.0, isLiked: false),
        .init(id: 2, testPic: "3", testTitle: "Долорес Клейборн", testYear: 1990, testRating: 6.5, isLiked: false),
        .init(id: 3, testPic: "4", testTitle: "Кладбище домашних животных", testYear: 2011, testRating: 10.0, isLiked: false),
        .init(id: 4, testPic: "5", testTitle: "Дети кукурузы", testYear: 2003, testRating: 7.4, isLiked: false),
        .init(id: 5, testPic: "6", testTitle: "Мизери", testYear: 1999, testRating: 8.8, isLiked: false),
        .init(id: 6, testPic: "1", testTitle: "Доктор сон", testYear: 1998, testRating: 9.8, isLiked: false),
        .init(id: 7, testPic: "2", testTitle: "1408", testYear: 1988, testRating: 5.6, isLiked: false),
        .init(id: 8, testPic: "3", testTitle: "Долорес Клейборн", testYear: 1986, testRating: 7.6, isLiked: false),
        .init(id: 9, testPic: "4", testTitle: "Кладбище домашних животных", testYear: 2011, testRating: 6.8, isLiked: false),
        .init(id: 10, testPic: "5", testTitle: "Дети кукурузы", testYear: 2014, testRating: 7.4, isLiked: false),
        .init(id: 11, testPic: "6", testTitle: "Мизери", testYear: 2002, testRating: 4.8, isLiked: false),
        .init(id: 12, testPic: "1", testTitle: "Доктор сон", testYear: 2004, testRating: 7.7, isLiked: false),
        .init(id: 13, testPic: "2", testTitle: "1408", testYear: 1999, testRating: 7.3, isLiked: false),
        .init(id: 14, testPic: "3", testTitle: "Долорес Клейборн", testYear: 1999, testRating: 6.8, isLiked: false),
    ]
    
    var newTestArray: [Item] = []
    
    var sortAscending: Bool = false
    
    var likedArrayItem: [Item] = []
    
    func showLikedItems() {
        var likedArray: [Item] = []
        for i in testArray {
            if i.isLiked == true{
                likedArray.append(i)
            }
        }
        likedArrayItem = likedArray
    }
    
    func toggleLike(index: Int) {
        testArray[index].isLiked.toggle()
    }
    
    func removeFromFavorite(id: Int) {
        for i in testArray {
            if i.id == id {
                i.isLiked.toggle()
            }
        }
    }
    
    func ratingSort() {
        self.testArray.sort {
            sortAscending ? ($0.testRating ?? 0) < ($1.testRating ?? 0) : ($0.testRating ?? 0) > ($1.testRating ?? 0)
        }
        newTestArray = testArray
    }
}
