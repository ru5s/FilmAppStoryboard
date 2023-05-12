//
//  FilimsAppStoryboardUITestsTarget.swift
//  FilimsAppStoryboardUITestsTarget
//
//  Created by Ruslan Ismailov on 02/05/23.
//

import XCTest

final class FilimsAppStoryboardUITestsTarget: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}
    
    //проверка нажатий на объекты приложения
    func testInterface() throws {
        
        //открываю приложение
        let app = XCUIApplication()
        //запускаю
        app.launch()
        
        //нахожу коллекцию на главном экране
        let collectionViewsQuery = app.collectionViews
        //нахожу ее ячейки
        let cellsQuery = collectionViewsQuery.cells
        //выбираю первую
        let firstCell = cellsQuery.children(matching: .any).element(boundBy: 0)
        //выбираю вторую ячейку чтоб ее добавить в избранные
        let secondCell = cellsQuery.children(matching: .any).element(boundBy: 1)
        //нажимаю на иконку сердечка
        secondCell.images["love"].tap()
        //даю свайп верх чтоб проверить скролл ячеек
        firstCell.swipeUp()
        //нахожу ячейку ниже
        let farCell = cellsQuery.children(matching: .any).element(boundBy: 5)
        //скролю на верх
        farCell.swipeDown()
        //нажиаю на первую ячейку
        firstCell.tap()
        //нахожу кнопку показать все скриншоты
        let forwardButton = app.buttons["allScreens"]
        //нажимаю по ней
        forwardButton.tap()
        //нахожу кнопку назад на вью со скринами
        let backButton = app.navigationBars["FilimsAppStoryboard.FilmPicsView"].buttons["Back"]
        //нажимаю
        backButton.tap()
        //нажимаю на сердечко избранных во вью о фильме
        app/*@START_MENU_TOKEN@*/.images["heart.fill"]/*[[".images[\"love\"]",".images[\"heart.fill\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        //нахожу навигационную панель вью о фильме
        let detailFilm = app.navigationBars["FilimsAppStoryboard.DetailFilmView"]
        //нахожу кнопку возврата на главный экран
        let backToMainButton = detailFilm.buttons["Films app"]
        //нажимаю на кнопку
        backToMainButton.tap()
        //нахожу навигационную панель, в ней нахожу сердечко, оно названо item и далее нажимаю на него
        app.navigationBars["Films app"].children(matching: .button).matching(identifier: "Item").element(boundBy: 0).tap()
        //нахожу колеекцию в избранных
        let favCollection = app.collectionViews.cells
        //выбираю первую ячейку
        let firstCellFavorite = favCollection.children(matching: .any).element(boundBy: 0)
        //нахожу сердечко для удаления из избранных
        let buttonFirstFav = firstCellFavorite.images["love"]
        //нажимаю
        buttonFirstFav.tap()
        //нажимаю кнопку назад для выхода на главный экран
        app.navigationBars["Liked movies"].buttons["Films app"].tap()
        
    }
    
}
