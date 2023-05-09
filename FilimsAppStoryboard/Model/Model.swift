//
//  Model.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/03/23.
//

import Foundation
import RealmSwift

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
    
    var likedArrayItem: Results<IsLikedFilmObjects>?
    
    var detailFilm: FilmObject?
    
    let urlService = URLService()
    
    var typeFilms: RequestOptions = .allMovie
    
//    var imageSet: [String] = []
    
    func showLikedItems() {
        let predicate = NSPredicate(format: "isLiked == true")
        likedArrayItem = likedFilms?.filter(predicate)
        
    }
    
    func detailFilm(id: Int){
        let film = filmObjects?.filter("id == \(id)")
        detailFilm = film?.first
        
    }
    
    func checkLikeFilm(id: Int) -> Bool {
        
        let predicate = NSPredicate(format: "id == \(id)")
        
        let likeId = likedFilms?.filter(predicate).first
        
//        return ((likeId?.isLiked) != nil)
        if likeId?.isLiked == true {
            return true
        }
        return false
    }
    
    func toggleLike(id: Int) {
        print("++ toggleLike \(id)")
        
        let predicate = NSPredicate(format: "id == \(id)")
        let likeIdFilmObjects = filmObjects?.filter(predicate)
        let likedFilm = likeIdFilmObjects?.first
        
        let likeIdIsLikedFilmObjects = likedFilms?.filter(predicate).first
        
        guard let likedFilm = likedFilm else {return}
        
        if likedFilm.isLiked || ((likeIdIsLikedFilmObjects?.isLiked) != nil) {
            
//            let predicate = NSPredicate(format: "id == \(id)")
            guard let unlike = likedFilms?.filter(predicate).first else { return }
            
            try! realm?.write({
                realm?.delete(unlike)
                
                likedFilm.isLiked = false
            })
            
        } else {
            
            try! realm?.write({
                
                let likeObject = IsLikedFilmObjects()
                
                likeObject.id = likedFilm.id
                likeObject.filmPic = likedFilm.filmPic
                likeObject.filmTitle = likedFilm.filmTitle
                likeObject.about = likedFilm.about
                likeObject.filmYear = likedFilm.filmYear
                likeObject.filmRating = likedFilm.filmRating
                likeObject.filmScreens.append(objectsIn: likedFilm.screenshots)
                likeObject.isLiked = true
                
                likedFilm.isLiked = true
             
                realm?.add(likeObject, update: .all)
            })
            
        }
        
    }
    
    func screenshotsLink(){
        
        let films = realm?.objects(FilmObject.self)
        
        guard let films = films else {return}
        
        for i in films {
            urlService.getScreenshots(i.id)
        }
        
        
    }
    
    func sortByType(type: RequestOptions) {
        
        typeFilms = type
        arrayHelper = filmObjects?.where({$0.type == type.rawValue})
        
        ratingSort()
    }
    
    func ratingSort() {
        arrayHelper = arrayHelper?.sorted(byKeyPath: "filmRating", ascending: sortAscending)
        print("++ ratingSort \(String(describing: realm?.configuration.fileURL))")
        
    }
    
    func search(searchTextValue: String) {
        let predicate = NSPredicate(format: "filmTitle CONTAINS [c]%@", searchTextValue)
        arrayHelper = filmObjects?.filter(predicate)
    }
}


extension Model {
    
    func addTestObjectToDataBase() {
        
        for i in 0...10 {
            let testObject = FilmObject()
            try! realm?.write({
                
                testObject.id = i
                testObject.filmTitle = "test #\(i)"
                testObject.filmYear = 0000
                testObject.filmRating = 10.0
                testObject.isLiked = false
                realm?.add(testObject, update: .all)
            })
            
        }
        
    }
    
    func removeTestObjectFromDataBase() {
        
        for i in 0...10 {
            let predicate = NSPredicate(format: "id == \(i)")
            let testObject = FilmObject()
            guard let removeObject = filmObjects?.filter(predicate).first else {return}
            try! realm?.write({
                realm?.delete(removeObject)
            })
        }
        
    }
    
    func addTestObjectToDataBaseSpecial(_ filmToTest: FilmObject) {
            
            let testObject = FilmObject()
            try! realm?.write({
                
                testObject.id = filmToTest.id
                testObject.isLiked = filmToTest.isLiked
                realm?.add(testObject, update: .all)
            })
            print("+++ testObject\(testObject.id)")
            print("+++ \(realm?.configuration.fileURL)")
            
        }
        
        func removeTestObjectFromDataBaseSpecial(_ filmToTest: FilmObject) {
            
            let predicate = NSPredicate(format: "id == \(filmToTest.id)")
            let testObject = FilmObject()
            guard let removeObject = filmObjects?.filter(predicate).first else {return}
            try! realm?.write({
                realm?.delete(removeObject)
            })
        }
        
        func firstObjectByID(_ id: Int) -> FilmObject? {
            
            let predicate = NSPredicate(format: "id == \(id)")
            let firstObjet = filmObjects?.filter(predicate).first
            guard let firstObjet = firstObjet else {return nil}
            
            return firstObjet
            
        }
}
