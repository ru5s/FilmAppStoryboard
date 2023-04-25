//
//  Model.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/03/23.
//

import Foundation
import RealmSwift


//class Item {
//
//    var id: Int?
//    var testPic: String?
//    var testTitle: String?
//    var testYear: Int?
//    var testRating: Double?
//    var isLiked: Bool
//
//    init (id: Int?, testPic: String?, testTitle: String?, testYear: Int?, testRating: Double?, isLiked: Bool) {
//        self.id = id
//        self.testPic = testPic
//        self.testTitle = testTitle
//        self.testYear = testYear
//        self.testRating = testRating
//        self.isLiked = isLiked
//    }
//}

class Model {
    
    let realm = try? Realm()
    
    var filmObjects: Results<FilmObject>? {
        return realm?.objects(FilmObject.self)
    }
    
    var likedFilms: Results<IsLikedFilmObjects>? {
        return realm?.objects(IsLikedFilmObjects.self)
    }
    
//    var newTestArray: [Item] = []
    
    var arrayHelper: Results<FilmObject>?
    
    var sortAscending: Bool = false
    
    var likedArrayItem: Results<FilmObject>?
    
    var detailFilm: FilmObject?
    
    let urlService = URLService()
    
    func showLikedItems() {
        let predicate = NSPredicate(format: "isLiked == true")
        likedArrayItem = filmObjects?.filter(predicate)
        
    }
    
    func detailFilm(id: Int){
        let film = filmObjects?.filter("id == \(id)")
        detailFilm = film?.first
    }
    
    func checkLikeFilm(id: Int) -> Bool {
        
        let predicate = NSPredicate(format: "id == \(id)")
        
        let likeId = filmObjects?.filter(predicate).first
        
        return ((likeId?.isLiked) != nil)
    }
    
    func toggleLike(id: Int) {
        
        let predicate = NSPredicate(format: "id == \(id)")
        let likeId = filmObjects?.filter(predicate)
        let likedFilm = likeId?.first
        
        guard let likedFilm = likedFilm else {return}
        
        try! realm?.write({
            likedFilm.isLiked = !likedFilm.isLiked
        })
    }
    
    func screenshotsLink(){
        
        let films = realm?.objects(FilmObject.self)
        
        guard let films = films else {return}
        
        for i in films {
            urlService.getScreenshots(i.id)
        }
        
        
    }
    
    
    func ratingSort() {
        arrayHelper = filmObjects?.sorted(byKeyPath: "filmRating", ascending: sortAscending)
        print("+++ \(String(describing: realm?.configuration.fileURL))")
    }
    
    func search(searchTextValue: String) {
        let predicate = NSPredicate(format: "filmTitle CONTAINS [c]%@", searchTextValue)
        arrayHelper = filmObjects?.filter(predicate)
    }
}
