//
//  Model.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/03/23.
//

import Foundation
import RealmSwift

//работа с моделью данных по всему приложению
class Model {
    //подключение к базе данных реалм
    let realm = try? Realm()
    //получение списка фильмов
    var filmObjects: Results<FilmObject>? {
        return realm?.objects(FilmObject.self)
    }
    //получение списка избранных фильмов
    var likedFilms: Results<IsLikedFilmObjects>? {
        return realm?.objects(IsLikedFilmObjects.self)
    }
    //вспомогательный массив для работы с фильтрами и чтоб не изменять основной массив из базы данных
    var arrayHelper: Results<FilmObject>?
    //булевая переменная для работы с фильтрацией по рейтингу
    var sortAscending: Bool = false
    //переменная для одного фильма
    var detailFilm: FilmObject?
    //менеджер работы с апи
    let urlService = URLService()
    
    //метод поиска в базе данных определенного фильма по id
    func detailFilm(id: Int){
        let film = filmObjects?.filter("id == \(id)")
        detailFilm = film?.first
    }
    
    //метод проверки фильма на наличие его в избранных и возврата булевого ответа
    func checkLikeFilm(id: Int) -> Bool {
        let predicate = NSPredicate(format: "id == \(id)")
        let likeId = likedFilms?.filter(predicate).first
        
        if likeId?.isLiked == true {
            return true
        }
        
        return false
    }
    
    //метод нажатие на кнопку избранных
    func toggleLike(id: Int) {
        //условие на поиск по id
        let predicate = NSPredicate(format: "id == \(id)")
        //поиск фильма в общем списке в базе данных
        let likedFilm = filmObjects?.filter(predicate).first
        //поиск фильма в списке избранных в базе данных
        let likeIdIsLikedFilmObjects = likedFilms?.filter(predicate).first
        //проверка на наличие данных
        guard let likedFilm = likedFilm else {return}
        //проверка если есть фильм в избранных в общем списке или есть фильм в избранных
        if likedFilm.isLiked || ((likeIdIsLikedFilmObjects?.isLiked) != nil) {
            //то его нужно сначала указать по id
            guard let unlike = likedFilms?.filter(predicate).first else { return }
            //потом убрать из избранных
            try! realm?.write({
                realm?.delete(unlike)
                //а так же в общем списке перевести булевую переменную
                likedFilm.isLiked = false
            })
        //если условия выше не выполнились то тогда
        } else {
            //попытаться сохранить в базу данных избрынных фильмов
            try! realm?.write({
                //создание объекта базы избранных
                let likeObject = IsLikedFilmObjects()
                //сохранение по пунктам
                likeObject.id = likedFilm.id
                likeObject.filmPic = likedFilm.filmPic
                likeObject.filmTitle = likedFilm.filmTitle
                likeObject.about = likedFilm.about
                likeObject.filmYear = likedFilm.filmYear
                likeObject.filmRating = likedFilm.filmRating
                likeObject.filmScreens.append(objectsIn: likedFilm.screenshots)
                likeObject.isLiked = true
                //изменения булевой переменной в фильме в основном списке базы данных
                likedFilm.isLiked = true
                //сохранение фильма в базу избранных
                realm?.add(likeObject, update: .all)
                //добавление типа фильма в базе избранных (на будущее)
                likeObject.type = likedFilm.type
            })
            
        }
        
    }
    
    func personalScrenshots(id: Int, completition: @escaping (Bool) -> ()) {
        urlService.getScreenshots(id, completition: {error in
            if let error = error {
                completition(false)
                print("++ urlService.personalScrenshots error - \(error)")
            } else {
                completition(true)
            }
        })
    }
    
    //метод сортировки по типу
    func sortByType(type: RequestOptions) {
        //вспомогательных массив для фильтрации по типу
        arrayHelper = filmObjects?.where({$0.type == type.rawValue})
        //запуск сортировки по рейтингу
        ratingSort()
    }
    
    //метод сортировки по рейтингу
    func ratingSort() {
        //выгрузка линка базы для открытия его локально
        print("++ realm data base url - \(String(describing: realm?.configuration.fileURL))")
        //этот же массив сортируем по рейтингу согласно булевой переменной sortAscending
        arrayHelper = arrayHelper?.sorted(byKeyPath: "filmRating", ascending: sortAscending)
    }
    
    //метод поиска фильма через строку поиска
    func search(searchTextValue: String) {
        //условия поиска
        let predicate = NSPredicate(format: "filmTitle CONTAINS [c]%@", searchTextValue)
        //фильтрация согласно условию
        arrayHelper = filmObjects?.filter(predicate)
    }
}

//расширение для работы с тестами
extension Model {
    
    //метод добавления тестового элемента
    func addTestObjectToDataBaseSpecial(_ filmToTest: FilmObject) {
            
        let testObject = FilmObject()
        
        try! realm?.write({
                
                testObject.id = filmToTest.id
                testObject.isLiked = filmToTest.isLiked
                realm?.add(testObject, update: .all)
            })
    }
    
    //метод удаления тестового элемента
    func removeTestObjectFromDataBaseSpecial(_ filmToTest: FilmObject) {
        
        let predicate = NSPredicate(format: "id == \(filmToTest.id)")
        guard let removeObject = filmObjects?.filter(predicate).first else {return}
        
        try! realm?.write({
            realm?.delete(removeObject)
        })
        
    }
    
    //поиск и передача тестовго элемента по id
    func firstObjectByID(_ id: Int) -> FilmObject? {
        
        let predicate = NSPredicate(format: "id == \(id)")
        let firstObjet = filmObjects?.filter(predicate).first
        guard let firstObjet = firstObjet else {return nil}
        
        return firstObjet
        
    }
    
    //метод для тестирования url и даты его даты
    func sendUrlToTest() -> URL? {
        
    let type: RequestOptions = .allMovie
        guard let url: URL = URL(string: "\(urlService.adress)3/movie/\(type.rawValue)?\(urlService.apiKey)&language=en-US&1") else { return URL(string: "")}
        
        return url
    }
    
}
