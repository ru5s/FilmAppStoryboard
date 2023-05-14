//
//  MainViewController.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/02/23.
//

import UIKit

//делегат для страницы подробнее о филме
protocol DetailFilmVCDelegate {
    func updateData()
}

//делегат для страницы избранных фильмов
protocol FavoriteVCDelegate {
    func updateData()
}

class MainViewController: UIViewController {
    
    //оутлеты со storyboard
    @IBOutlet weak var collectioView: UICollectionView!
    
    @IBOutlet weak var popularBtn: UIButton!
    
    @IBOutlet weak var topRatedBnt: UIButton!
    
    @IBOutlet weak var watchNowBtn: UIButton!
    
    @IBOutlet weak var sortBtn: UIBarButtonItem!
    
    //строка поиска
    var searchController = UISearchController()
    
    //модель данных и их возможная обработка с базой данных
    var model = Model()
    
    //индекс (или id) фильма что передаем на страницу подробнее о фильме
    var detailedFilmIndex: Int?
    
    //класс работающий с запросами к апи
    let urlService = URLService()
    
    //страница по умолчанию при запуске приложения
    var page: Int = 1
    
    //тип запроса для сепарации списка фильмов (смотрят, топ рейтинг, популярные)
    var typeMovie: RequestOptions = .allMovie
    
    //добавление группы для получения данных с апи и только потом их грузить в приложение асинхронно
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //уравнивание вспомогательного массива с общим массивом для последующей его фильтрации
        model.arrayHelper = model.filmObjects
        
        //делегат и дата соурс коллекции
        collectioView.delegate = self
        collectioView.dataSource = self
        
        //добавление стилей для кнопок запускающий фильтрацию по типу
        popularBtn.backgroundColor = .systemTeal
        popularBtn.layer.cornerRadius = 10
        topRatedBnt.backgroundColor = .systemGray2
        topRatedBnt.layer.cornerRadius = 10
        watchNowBtn.backgroundColor = .systemGray2
        watchNowBtn.layer.cornerRadius = 10
        
        //получение данных с апи
        fetchData()
        
        //добавление кастомной xib ячейки
        let xibCell = UINib(nibName: "MainFilmCollectionViewCell", bundle: nil)
        collectioView.register(xibCell, forCellWithReuseIdentifier: "FilmCell")
        
        //подключение делегата для поисковой строки и добавление тескста в placeholder
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Find Your Film"
        
        //добавление поиска в навигатор
        navigationItem.searchController = searchController
        //запрет на сворачивание когда идет скролл
        navigationItem.hidesSearchBarWhenScrolling = false
        
        //дополнительная защита для обновления коллекции
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.collectioView.reloadData()
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {

    }
    
    func fetchData() {
        
        DispatchQueue.main.async {
            //получение данных в асинхронном режиме, в методе стоит сбегающее замыкание на то что данные уже в базе данных
            self.urlService.dataRequest(page: self.page, requestOptions: self.typeMovie, completition: { bool in
                
                if bool == true {
                    
                    DispatchQueue.main.async {
                        self.model.sortByType(type: self.typeMovie)
                        
                        //обновление коллекции после
                        self.collectioView.reloadData()
                    }
                }
            })
            
        }
        
    }
    
    //кнопка сортировки фильмов по рейтингу
    @IBAction func sortBtnAction(_ sender: Any) {
        
        //поворот стрелки при нажатии
        model.sortAscending ? (sortBtn.image = UIImage(systemName: "arrow.up")) : (sortBtn.image = UIImage(systemName: "arrow.down"))
        
        //сортировка фильмов по типу
        model.sortByType(type: typeMovie)
        
        //смена булевой для сортировки по рейтингу
        model.sortAscending.toggle()
        
        //сортировка по рейтингу
        model.ratingSort()
        
        collectioView.reloadData()
    }
    
    //кнопка popular
    @IBAction func tappedPopular(_ sender: Any) {
        
        //подсвечивание необходимой и декативацию остальных
        popularBtn.backgroundColor = .systemTeal
        topRatedBnt.backgroundColor = .systemGray2
        watchNowBtn.backgroundColor = .systemGray2
        
        //указание типа фильма
        typeMovie = .allMovie
        
        //запрос к апи для получения данных
        urlService.dataRequest(page: page, requestOptions: typeMovie, completition: {bool in
            if bool == true {
                DispatchQueue.main.async {
                    //сортировка фильмов по типу
                    self.model.sortByType(type: self.typeMovie)
                    
                    self.collectioView.reloadData()
                    
                    //прокручивание коллекции в самый верх при нажатии
                    self.collectioView.setContentOffset(.zero, animated: true)
                }
            }
        })
        
    }
    
    //кнопка top rated
    @IBAction func tappedTopRated(_ sender: Any) {
        
        topRatedBnt.backgroundColor = .systemTeal
        popularBtn.backgroundColor = .systemGray2
        watchNowBtn.backgroundColor = .systemGray2
        
        typeMovie = .topRated
        
        urlService.dataRequest(page: page, requestOptions: typeMovie, completition: {bool in
            
            if bool == true {
                DispatchQueue.main.async {
                    //сортировка фильмов по типу
                    self.model.sortByType(type: self.typeMovie)
                    
                    self.collectioView.reloadData()
                    
                    //прокручивание коллекции в самый верх при нажатии
                    self.collectioView.setContentOffset(.zero, animated: true)
                    
                }
            }
            
        })
        
    }
    
    //кнопка watch now
    @IBAction func tappedWatchNow(_ sender: Any) {
        
        watchNowBtn.backgroundColor = .systemTeal
        topRatedBnt.backgroundColor = .systemGray2
        popularBtn.backgroundColor = .systemGray2
        
        typeMovie = .nowPlaying
        
        urlService.dataRequest(page: page, requestOptions: typeMovie, completition: {bool in
            if bool == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    //сортировка фильмов по типу
                    self.model.sortByType(type: self.typeMovie)
                    
                    self.collectioView.reloadData()
                    
                    //прокручивание коллекции в самый верх при нажатии
                    self.collectioView.setContentOffset(.zero, animated: true)
                }
            }
        })

    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //ограничение на количество ячеек
        guard let filmObjectsCount = model.arrayHelper?.count else {
            return Int()
        }
        return filmObjectsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //подключение кастомной ячейки
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilmCell", for: indexPath) as? MainFilmCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        //изменение внешнего вида элементов в ячейке
        cell.posterPreviewImageView.layer.cornerRadius = 5
        cell.releaseYearLabel.font = UIFont.italicSystemFont(ofSize: 21)
        cell.viewBelowRating.layer.cornerRadius = 10
        cell.likeImage.layer.opacity = 0.75
        
        //получение данных с базы данных
        cell.data = self.model.arrayHelper?[indexPath.item]
        
        //проверка есть ли в избранных фильм и подсветка сердечка избранных
        model.checkLikeFilm(id: Int(model.arrayHelper?[indexPath.row].id ?? 0)) ? (cell.likeImage.tintColor = .red) : (cell.likeImage.tintColor = .gray)
        
        //добавление кастомного нажатия на сердечко избраннх
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapOnLikeImage))
        cell.likeImage.isUserInteractionEnabled = true
        //передача в тэг номера id фильма
        cell.likeImage.tag = model.arrayHelper?[indexPath.row].id ?? 0
        cell.likeImage.addGestureRecognizer(tap)
        
        return cell
    }
    
    //кастомное нажатие на сердечко избранных
    @objc func tapOnLikeImage(sender: UITapGestureRecognizer){
        
        //получение id фильма из тэга
        let id = sender.view?.tag
        
        //проверка на пустоту
        guard let id = id else {return}
        
        DispatchQueue.main.async {
            //добавление плавности закрашивания сердечка
            UIView.animate(withDuration: 0.2) {
                sender.view?.tintColor == .red ? (sender.view?.tintColor = .gray) : (sender.view?.tintColor = .red)
            }
            
            //добавление или удаления фильма из избранных
            self.model.toggleLike(id: id)

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let idFilm = self.model.arrayHelper?[indexPath.row].id else {return}
        
        //получение id для последующей передачи его во вью detailed film
        detailedFilmIndex = model.arrayHelper?[indexPath.row].id
        
        //передача данных через сегвей
        performSegue(withIdentifier: "DetailFilmSegue", sender: nil)
    }
    
    //метод передачи данных через сегвей
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //отображение страницы избранных фильмов
        if segue.identifier == "likeData" {
            
            let favVC = segue.destination as! FavoriteFilmsViewController
            favVC.delegate = self
            
        }

        //отображение страницы о фильме
        if segue.identifier == "DetailFilmSegue" {
            let detailVC = segue.destination as! DetailFilmViewController
            
            //проверка на наличие данных
            guard let detailedFilmIndex = detailedFilmIndex else {return}
            
            //передача id фильма
            detailVC.getData(item: detailedFilmIndex)
            
            //делегат получения обратных данных
            detailVC.delegate = self
        }
    }
    
}

extension MainViewController: DetailFilmVCDelegate, FavoriteVCDelegate {
    
    //при получении обратных данных обновлять коллекцию
    func updateData(){
        DispatchQueue.main.async {
            self.collectioView.reloadData()
        }
    }
}

extension MainViewController: UISearchBarDelegate{
    
    //работа со строкой поиска
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //приравнивание вспомогательного массива к массиву всех фильмов что есть в базе
        model.arrayHelper = model.filmObjects
        
        //запус метода поиска по введенному тексту
        model.search(searchTextValue: searchText)
        
        //если поисковая строка пустая то производить обратное приравнивание и сортировку
        if searchText.isEmpty {
            model.arrayHelper = model.filmObjects
            model.sortByType(type: typeMovie)
        }
        
        DispatchQueue.main.async {
            self.collectioView.reloadData()
        }
    }
    
    //метод нажатия кнопки отмены
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        model.arrayHelper = model.filmObjects
        
        model.sortByType(type: typeMovie)
        
        DispatchQueue.main.async {
            self.collectioView.reloadData()
        }
    }
}
