//
//  FilimsAppStoryboardTestsTarget.swift
//  FilimsAppStoryboardTestsTarget
//
//  Created by Ruslan Ismailov on 02/05/23.
//

import XCTest
@testable import FilimsAppStoryboard
@testable import Pods_FilimsAppStoryboard

final class FilimsAppStoryboardTestsTarget: XCTestCase {
    
    //подключение в модели данных
    let model = Model()
    //ожидаемый результат теста
    var expectation: XCTestExpectation?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //проверка удаленного доступа к апи
    func testURL() throws {
        
        //метод получения url в котором вложены оригинальный апи ключ и тип запроса
        guard let url = model.sendUrlToTest() else {
            //ошибка маловероятная но идея была привязывать данные с модели но тесты не проходят из за этого
            XCTFail("url not found")
            
            return
            
        }
        
        //асинхронное предупреждение что процесс запустился
        expectation = expectation(description: "api.themoviedb")
        
        //задача для получения данных через ссылку
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            //проверка на нил даты
            XCTAssertNotNil(data, "the data should not be nil")
            //проверка на нил ошибки
            XCTAssertNil(error, "data must be nil")
            
            //защита на получение запроса
            if let httpResponse = response as? HTTPURLResponse,
               let urlResponse = httpResponse.url {
                //проверка на совпадение url с url из метода
                XCTAssertEqual(urlResponse.absoluteString, url.absoluteString, "url from http must be equal original url")
                //проверка на получение отетного кода с апи
                XCTAssertEqual(httpResponse.statusCode, 200, "answer status code must be equal 200")
                
            } else {
                //ошибка
                XCTFail("can't get answer NSHTTPURLResponse")
                
            }
            //окончание процесса
            self.expectation?.fulfill()
            
        }
        
        task.resume()
        //ожидание асинхронного предупреждения
        waitForExpectations(timeout: task.originalRequest?.timeoutInterval ?? 10) {error in
            //в случае не получения ответа то выкидываем ошибку
            if let error = error {
                
                print("Error: \(error.localizedDescription)")
                
            }
            
            task.cancel()
            
        }
        
    }
    
    //проверка на работу нажатия на избранные
    func testToggleLikeModel() throws {
        //константа для проверки на правду (как вариант добавил)
        let testLike: Bool = true
        
        //создание объекта для реалм базы данных
        let firstObject = FilmObject()
        //передача в него необходимых минимальных параметров для проверки теста
        firstObject.id = 1
        firstObject.isLiked = false
        
        //метод добавление тестового объекта в базу данных
        model.addTestObjectToDataBaseSpecial(firstObject)
        //получение этого объекта с базы данных
        let item = model.firstObjectByID(firstObject.id)
        //проверка id на пустоту
        guard let id: Int = item?.id else { return XCTFail("id not be found")}
        //если объект был не избран
        
        if item?.isLiked == false {
            //проверяем метод нажатия на лайк (метод в приложении)
            model.toggleLike(id: id)
            //нахдим этот объект из базы данных
            let likedItem = model.firstObjectByID(id)
            //проверяем его с константой на правду
            XCTAssertEqual(likedItem?.isLiked, testLike, "something wrong with method toggle like")
            //проверяем на пустоту опционал
            guard let likedId: Int = likedItem?.id else { return XCTFail("id not be found")}
            //проверяем метод проверки на наличие объекта в избранных (метод в приложении)
            let methodCheck = model.checkLikeFilm(id: likedId)
            //сверяем
            XCTAssertTrue(methodCheck, "somthing wrong with method check like film")
        }
        
        //после того как его добавили в избранные нужно его деактивировать
        if item?.isLiked == true {
            //проверяем деактивацию метода нажатия на лайк
            model.toggleLike(id: id)
            //находим этот объект из базы данных
            let methodCheck = model.checkLikeFilm(id: id)
            //проверяем
            XCTAssertFalse(methodCheck, "somthing wrong with method check like film")
        }
        //удаляем объект из базы данных
        model.removeTestObjectFromDataBaseSpecial(firstObject)
        
    }
    
}
