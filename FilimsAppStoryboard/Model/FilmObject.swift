//
//  FilmObject.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 28/03/23.
//

import Foundation
import RealmSwift

class FilmObject: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var filmPic: String = ""
    @objc dynamic var filmTitle: String = ""
    @objc dynamic var filmYear: Int = 0000
    @objc dynamic var filmRating: Double = 0.0
//    @objc dynamic var filmScreens: String = ""
    dynamic var screenshots: List<String> = List<String>()
    @objc dynamic var about: String = ""
    @objc dynamic var isLiked: Bool = false
    @objc dynamic var type: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
