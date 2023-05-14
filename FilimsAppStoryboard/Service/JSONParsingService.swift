//
//  JSONParsingService.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 10/04/23.
//

import Foundation
import RealmSwift

//класс работы с сохранением данных в базу данных реалм
class JSONParsingService {
    //подключение к базе данных реалм
    let realm = try? Realm()
    
    //метод получения линков скриншотов в конкретный фильм
    func parseLinkToScreenshots(parseData: Data, parseError: Error?, id: Int, completition: @escaping (Error?) -> Void) {
        //запрос на попытку исполнения кода с выкидыванием ошибки в случае неудачи
        do {
            //декодирование данных json
            let imageSet = try JSONDecoder().decode(AllScreens.self, from: parseData)
            //обращение к конкретному пункту модели, где хранится массив ссылкок на скриншоты
            let jsonObjects = imageSet.backdrops
            //подключение к раелм
            let realm = try? Realm()
            //константа со всеми филмами с базы данных
            let films = realm?.objects(FilmObject.self)
            //попытка сохранить данных в базу
            try realm?.write({
                //проверка на наличие базы
                guard let films = films else {return}
                //создание условия поиска совпадений
                let predicate = NSPredicate(format: "id == \(id)")
                //вывод первого совпавшего фильма, так как у все id индивидуальный то это будет всегда одно кино
                let thisFilm = films.filter(predicate).first
                //создание пустого массива, в который будут сохраняться линки
                var links: [String] = []
                
                for item in jsonObjects {
                    //проверка на наличие линка
                    guard let filePath = item.file_path else {return}
                    //сохранение в массив
                    links.append(filePath)
                    
                }
                //проверка если количество линков у фильма в базе данных больше одного то пропускать сохранение
                if thisFilm?.screenshots.count ?? 0 < 1 {
                    //иначе сохранить массив с линками в фильм
                    thisFilm?.screenshots.append(objectsIn: links)
                    
                } else {
                    return
                }
                
            })
            completition(nil)
        //выдать ошибку в случае провала
        } catch let error {
            completition(error)
            print("++ parseLinkToScreenshots error - \(error)")
            
        }
    }
    
    
    //метод сохранения фильмов в базу данных со сбегающим замыканием после сохранения данных
    func parseJSON(parseData: Data, parseError: Error?, type: String, completition: @escaping (Bool) -> ()) {
        
        do {
            //декодирование фильмов через модель данных
            let filmObject = try JSONDecoder().decode(MovieList.self, from: parseData)
            //получение определенного пункта модели данных
            let jsonObjects = filmObject.results
            //подключение к базе данных реалм
            let realm = try? Realm()
            //проверка на наличие данных
            guard let jsonObjects = jsonObjects else {return}
            //попытка сохранить данные в базу
            try! realm?.write({
                
                for item in jsonObjects {
                    //создание макета модели фильма в базе данных
                    let object = FilmObject()
                    //проверка на наличие данных в json
                    if let unwrId = item.id,
                       let unwrFilmPic = item.poster_path,
                       let unwrFilmTitle = item.original_title,
                       let unwrAbout = item.overview ,
                       let unwrFilmYear = item.release_date,
                       let unwrFilmRating = item.vote_average
                        
                    {
                        //передача данных по пунктам
                        object.id = unwrId
                        object.filmPic = unwrFilmPic
                        object.filmTitle = unwrFilmTitle
                        object.about = unwrAbout
                        object.filmYear = Int(unwrFilmYear.prefix(4)) ?? 0000
                        object.filmRating = unwrFilmRating
                        
                    }
                    //создание объекта в базе данных либо обноление существующих
                    realm?.add(object, update: .all)
                    //дополнительно изменение в уже созданном объекте
                    //всегда делать фильм не избранным
                    object.isLiked = false
                    //передача типа фильма согласно запросу, для дальнейшего фильтра по этому пункту
                    object.type = type
                }
                //выгрузка линка базы для открытия его локально
                print("++ realm data base url - \(String(describing: realm?.configuration.fileURL))")
                //подтверждение сохранения данных
                completition(true)
            })
            
        } catch let error {
            completition(false)
            print("++ parseJSON error - \(error)")
            
        }
        
    }
    
}
