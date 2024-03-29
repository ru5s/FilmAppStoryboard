//
//  isLikedFilmObjects.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 10/04/23.
//

import Foundation
import RealmSwift

//Модель объекта Реалм базы данных для избранных фильмов
class IsLikedFilmObjects: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var filmPic: String = ""
    @objc dynamic var filmTitle: String = ""
    @objc dynamic var filmYear: Int = 0000
    @objc dynamic var filmRating: Double = 0.0
    dynamic var filmScreens: List<String> = List<String>()
    @objc dynamic var about: String = ""
    @objc dynamic var isLiked: Bool = true
    @objc dynamic var type: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
