//
//  URLService.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 01/04/23.
//

import Foundation
import UIKit

enum RequestOptions: String {
    case allMovie = "popular"
    case latest = "latest"
    case nowPlaying = "now_playing"
    case topRated = "top_rated"
    case upcoming = "upcoming"
    
}

class URLService {
    
    let adress: String = "https://api.themoviedb.org/"
    
    let apiKey: String = "api_key=f4da188878dec2aea2a0e9db582199b5"
    
    let session = URLSession.shared
    
    let parser = JSONParsingService()
    
    var imageCache = NSCache <NSString, UIImage>()
    
    func dataRequest(page: Int = 1, requestOptions: RequestOptions = .allMovie) {
        
        var page = "&page=\(page)"
        
        requestOptions == .latest ? (page = "") : (page = "page=\(page)")
        
        guard let apiUrl: URL = URL(string: "\(adress)3/movie/\(requestOptions.rawValue)?\(apiKey)&language=en-US&\(page)") else { return }
        
        let task = session.dataTask(with: apiUrl) { data, response, error in
            
            guard let unwrData = data,
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  error == nil else {
                return
            }
            
//            print("++ \(String(data: unwrData, encoding: .utf8)) ")
            
            self.parser.parseJSON(parseData: unwrData, parseError: error, type: requestOptions.rawValue)
            
        }
        task.resume()
    }
    
    func getScreenshots(_ filmId: Int) {
        
        let assetAdress: String = "https://api.themoviedb.org/3/movie/"
        
        guard let assetApiUrl: URL = URL(string: "\(assetAdress)\(filmId)/images?\(apiKey)") else {return}
        
        let task = session.dataTask(with: assetApiUrl) {data, response, error in
            
            guard let unwrData = data,
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  error == nil else {
                return
            }
            
            self.parser.parseLinkToScreenshots(parseData: unwrData, parseError: error, id: filmId)
//            print(String(data: unwrData, encoding: .utf8) as Any)
            
        }
        task.resume()
    }
    
    func getSetPoster(withUrl url: URL, comletition: @escaping (UIImage) -> Void) {
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            comletition(cachedImage)
        } else {
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10.0)
            
            let downloadingTask = session.dataTask(with: request) {[weak self] data, response, error in
                
                guard error == nil,
                let unwrData = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let self = self else {
                    return
                }
                
                guard let image = UIImage(data: unwrData) else {
                    return
                }
                
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    comletition(image)
                }
                
            }
            
            downloadingTask.resume()
        }
        
    }
    
}

/*
 
 Latest - https://api.themoviedb.org/3/movie/latest?api_key=f4da188878dec2aea2a0e9db582199b5&language=en-US

 Now Playing - https://api.themoviedb.org/3/movie/now_playing?api_key=f4da188878dec2aea2a0e9db582199b5&language=en-US&page=1

 Top Rated - https://api.themoviedb.org/3/movie/top_rated?api_key=f4da188878dec2aea2a0e9db582199b5&language=en-US&page=1

 Upcoming - https://api.themoviedb.org/3/movie/upcoming?api_key=f4da188878dec2aea2a0e9db582199b5&language=en-US&page=1
 
 */
