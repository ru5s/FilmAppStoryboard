//
//  JSONParsingService.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 10/04/23.
//

import Foundation
import RealmSwift

class JSONParsingService {
    var filmObjects: Results<FilmObject>?
    
    func parseLinkToScreenshots(parseData: Data, parseError: Error?, id: Int) {
        do {
            
            let imageSet = try JSONDecoder().decode(AllScreens.self, from: parseData)
            let jsonObjects = imageSet.backdrops
            
            let realm = try? Realm()
            let films = realm?.objects(FilmObject.self)
            
            try realm?.write({
                
                guard let films = films else {return}
                
                let predicate = NSPredicate(format: "id == \(id)")
                
                let thisFilm = films.filter(predicate).first
                
                var links: [String] = []
                
                for item in jsonObjects {
                    
                    guard let filePath = item.file_path else {return}
                    links.append(filePath)
                    
                }
                
                if thisFilm?.screenshots.count ?? 0 < 1 {
                    thisFilm?.screenshots.append(objectsIn: links)
                    
                    guard let thisFilm = thisFilm else {return}
                    
                    realm?.add(thisFilm, update: .all)
                    
                } else {
                    
                    return
                }
                
            })
            
        } catch let error {
            
            print("+++ \(error)")
            
        }
    }
    
    func parseJSON(parseData: Data, parseError: Error?) {
        
        do {
            
            let filmObject = try JSONDecoder().decode(MovieList.self, from: parseData)
            let jsonObjects = filmObject.results
            let realm = try? Realm()
            
            guard let jsonObjects = jsonObjects else {return}
            
            try realm?.write({
                
                for item in jsonObjects {
                    let object = FilmObject()
                    
                    if let unwrId = item.id,
                       let unwrFilmPic = item.poster_path,
                       let unwrFilmTitle = item.original_title,
                       let unwrAbout = item.overview ,
                       let unwrFilmYear = item.release_date,
                       let unwrFilmRating = item.vote_average
                        
                    {
                        
                        object.id = unwrId
                        object.filmPic = unwrFilmPic
                        object.filmTitle = unwrFilmTitle
                        object.about = unwrAbout
                        object.filmYear = Int(unwrFilmYear.prefix(4)) ?? 0000
                        object.filmRating = unwrFilmRating
                        object.isLiked = false
                    }
                    
                    
                    
                    realm?.add(object, update: .all)
                    
                }
                
            })
            print(realm?.configuration.fileURL as Any)
        } catch let error {
            
            print(error)
            
        }
        
    }
    
}
