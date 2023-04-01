//
//  Model.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/03/23.
//

import Foundation
import RealmSwift


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
    
    let realm = try? Realm()
    var filmObjects: Results<FilmObject>? {
        return realm?.objects(FilmObject.self)
    }
    
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
    var arrayHelper: Results<FilmObject>?
    
    var sortAscending: Bool = false
    
    var likedArrayItem: Results<FilmObject>?
    
    var detailFilm: FilmObject?
    
//    func readRealmData() {
//        filmObjects = realm?.objects(FilmObject.self)
//        print(realm?.configuration.fileURL)
//    }
    
    func showLikedItems() {
        let predicate = NSPredicate(format: "isLiked == true")
        likedArrayItem = filmObjects?.filter(predicate)
        
    }
    
    func detailFilm(id: Int){
        let film = filmObjects?.filter("id == \(id)")
        detailFilm = film?.first
    }
    
    func toggleLike(index: Int) {
        
        if let likedFilm = filmObjects?[index] {
            do {
                
                try! realm?.write({
                    
                    likedFilm.isLiked = !likedFilm.isLiked
                    
                })
                
            } catch {
                
                print("Error saving done status, \(error)")
                
            }
        }
        
    }
    
    func removeFromFavorite(id: Int) {
        if let likedFilm = filmObjects?[id] {
            do {
                
                try! realm?.write({
                    
                    likedFilm.isLiked = !likedFilm.isLiked
                    
                })
                
            } catch {
                
                print("Error saving done status, \(error)")
                
            }
        }
    }
    
    func ratingSort() {
//        self.testArray.sort {
//            sortAscending ? ($0.testRating ?? 0) < ($1.testRating ?? 0) : ($0.testRating ?? 0) > ($1.testRating ?? 0)
//        }
//        newTestArray = testArray
        
        arrayHelper = filmObjects?.sorted(byKeyPath: "testRating", ascending: sortAscending)
    }
    
    func search(searchTextValue: String) {
//        newTestArray = []
//
//        if searchTextValue == "" {
//            newTestArray = testArray
//        } else {
//            for item in testArray {
//                guard let unwrItem = item.testTitle else {
//                    return
//                }
//
//                if unwrItem.contains(searchTextValue) {
//                    newTestArray.append(item)
//                }
//            }
//        }
//
//        newTestArray = testArray.filter({
//            $0.testTitle?.range(of: searchTextValue, options: .caseInsensitive) != nil
//        })
        
        let predicate = NSPredicate(format: "testTitle CONTAINS [c]%@", searchTextValue)
        
        arrayHelper = filmObjects?.filter(predicate)
    }
}
