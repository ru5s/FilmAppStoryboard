//
//  URLService.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 01/04/23.
//

import Foundation
import UIKit

//все возможные варинаты запроса в апи (в приложении используется только 3)
enum RequestOptions: String {
    case allMovie = "popular"
    case latest = "latest"
    case nowPlaying = "now_playing"
    case topRated = "top_rated"
    case upcoming = "upcoming"
    
}

//менеджер работы с апи
class URLService {
    //общая часть url для работы с запросами к апи
    let adress: String = "https://api.themoviedb.org/"
    //ключ
    let apiKey: String = "api_key=f4da188878dec2aea2a0e9db582199b5"
    //сессия к запросу url
    let session = URLSession.shared
    //подключение парсера для сохранения в базу данных реалм
    let parser = JSONParsingService()
    //переменная для хранения кэша картинок, обращение идет по ключу (ulr в качестве ключа)
    var imageCache = NSCache <NSString, UIImage>()
    
    //запрос к апи на получения списка фильмов со сбегающим булевым замыканием на окончание процесса
    func dataRequest(page: Int = 1, requestOptions: RequestOptions = .allMovie, completition: @escaping (Bool) -> ()) {
        //страница запроса
        var page = "&page=\(page)"
        //так как в запросе .latest отсутствует параметр page то создано условие
        requestOptions == .latest ? (page = "") : (page = "page=\(page)")
        //полный url запроса с его проверкой на нил
        guard let apiUrl: URL = URL(string: "\(adress)3/movie/\(requestOptions.rawValue)?\(apiKey)&language=en-US&\(page)") else { return }
        //создание задачи на получение данных
        let task = session.dataTask(with: apiUrl) { data, response, error in
            //распаковка данных с проверкой на получение статус кода
            guard let unwrData = data,
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  error == nil else {
                completition(false)
                return
            }
            
            //отправка данных в парсер с сохранением всего в базу данных и получение ответа при достижении результата
            self.parser.parseJSON(parseData: unwrData, parseError: error, type: requestOptions.rawValue, completition: { bool in
                
                //если результат пришел то отправить сигнал
                if bool == true {
                    completition(true)
                }
            })
            
        }
        task.resume()
    }
    
    //метод получения скриншотов по id фильма
    func getScreenshots(_ filmId: Int) {
        //общая часть url запроса
        let assetAdress: String = "https://api.themoviedb.org/3/movie/"
        //полный url с проверкой состояния
        guard let assetApiUrl: URL = URL(string: "\(assetAdress)\(filmId)/images?\(apiKey)") else {return}
        //создание задачи
        let task = session.dataTask(with: assetApiUrl) {data, response, error in
            //проверка данных с проверкой статус кода
            guard let unwrData = data,
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  error == nil else {
                return
            }
            //отправка данных в парсер для сохранения линков в конкретный фильм в базе данных
            self.parser.parseLinkToScreenshots(parseData: unwrData, parseError: error, id: filmId)
            
        }
        task.resume()
    }
    
    //метод скачивания и кэширования картинок
    func getSetPoster(withUrl url: URL, comletition: @escaping (UIImage) -> Void) {
        //проверка есть ли картинка в кэшах по средствам отправки в него ключа в виде полного url картинки
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            //если есть то отправить в сбегающее замыкание картинку
            comletition(cachedImage)
        } else {
            //иначе создать запрос с сохранением картинки в кэш
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10.0)
            //задача на скачивание данных
            let downloadingTask = session.dataTask(with: request) {[weak self] data, response, error in
                //проверка на ошибку, данных, проверки статус кода, и самого себя
                guard error == nil,
                let unwrData = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let self = self else {
                    return
                }
                
                //проверка на то что пришла картинка
                guard let image = UIImage(data: unwrData) else {
                    return
                }
                //сохраниение картинки в кэш
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    //отправка картинки через сбегающее замыкание
                    comletition(image)
                }
                
            }
            
            downloadingTask.resume()
        }
        
    }
    
}
