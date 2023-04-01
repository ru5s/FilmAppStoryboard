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
    @objc dynamic var testPic: String = ""
    @objc dynamic var testTitle: String = ""
    @objc dynamic var testYear: String = ""
    @objc dynamic var testRating: Double = 0.0
    @objc dynamic var isLiked: Bool = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
