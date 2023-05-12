//
//  DetailFilmViewController.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/02/23.
//

import UIKit
import RealmSwift

class DetailFilmViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    //оутлеты со сториборда
    @IBOutlet weak var isLikeIcon: UIImageView!
    
    @IBOutlet weak var filmPoster: UIImageView!
    
    @IBOutlet weak var filmTitleLabel: UILabel!
    
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var framesMovieCollectionView: UICollectionView!
    
    @IBOutlet weak var descriptionLablel: UITextView!
    
    @IBOutlet var storyboardTapGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var allScreensButton: UIButton!
    
    //переменная для получения картинки из коллекции и передачи его на другой вью
    var fullPicImage: UIImage?
    
    //делегат для главной странцы
    var delegate: DetailFilmVCDelegate?
    
    //подключение кастомной анимации
    var transition: RoundingTransition = RoundingTransition()
    
    //модель данных
    let model = Model()
    
    //образец избранного фильма
    var choosedItem: FilmObject?
    
    //общая часть url адреса для получения картинки
    let adress: String = "https://image.tmdb.org/t/p/w500"
    //подключение сервиса работы с апи
    let urlService = URLService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //добавляем возможность отследить кнопку в ui тестах
        allScreensButton.accessibilityIdentifier = "allScreens"
        
        //добавление стиля для кнопки просмотра всех скриншотов
        allScreensButton.layer.cornerRadius = 0
        allScreensButton.backgroundColor = .black.withAlphaComponent(0.6)
        
        //подключение кастомного нажатия для сердечка избранных
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(toggleLike))
        
        //добавление стиля для сердечка избранного
        isLikeIcon.layer.opacity = 0.75
        isLikeIcon.isUserInteractionEnabled = true
        isLikeIcon.addGestureRecognizer(tap)
        
        
        DispatchQueue.main.async {
            
            //защита выбранного элемента от пустоты и получения полного url для основной картинки
            guard let unwrData = self.choosedItem, let url = URL(string: self.adress + unwrData.filmPic) else {
                return
            }
            
            //метод получения картинки из апи либо из кэша
            self.urlService.getSetPoster(withUrl: url) { image in
                self.filmPoster.image = image
            }
            
            //заполнение всех элементов текста на странице
            self.filmTitleLabel.text = self.choosedItem?.filmTitle
            self.releaseYearLabel.text = "Release: \(String(self.choosedItem?.filmYear ?? 0000))"
            self.ratingLabel.text = "Rating \(String(self.choosedItem?.filmRating ?? 0))"
            self.descriptionLablel.text = self.choosedItem?.about ?? ""
            
            //проверка фильма на избранные, так как он хранится в другом спискае в базе данных
            self.model.checkLikeFilm(id: self.choosedItem?.id ?? 0) ? (self.isLikeIcon.tintColor = .red) : (self.isLikeIcon.tintColor = .gray)
        }
        
        //подключение делегатов и даты соурс для коллекции скриншотов
        framesMovieCollectionView.delegate = self
        framesMovieCollectionView.dataSource = self
        
        DispatchQueue.main.async {
            self.framesMovieCollectionView.reloadData()
        }
    }
    
    //без пустого экшена кнопки "показать все скриншоты в отдельном вью" выходит ошибка передачи данных
    @IBAction func openAllScreenshots(_ sender: Any) {}
    
    //метод кастомного нажатия на сердечко избранного
    @objc func toggleLike() {
        guard let id = choosedItem?.id else {return}
        
        //отработка метода нажатия в модели
        model.toggleLike(id: id)
        //проверка на состояние
        choosedItem?.isLiked ?? false ? (isLikeIcon.tintColor = .red) : (isLikeIcon.tintColor = .gray)
        //обновление данных на главной странце
        delegate?.updateData()
    }
    
    //метод получения id для отображения необходимого фильма
    func getData(item: Int) {
        
        //получение фильма из списка в базе данных по совпадению id
        choosedItem = model.filmObjects?.where({ film in
            film.id == item
        }).first
        
    }
    
    //метод кастомной анимации при появлении
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionProfile = .show
        transition.start = filmPoster.center
        transition.roundColor = UIColor.black
        
        return transition
    }
    
    //метод кастомной анимации при исчезании
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionProfile = .cancel
        transition.time = 1.0
        transition.start = filmPoster.center
        transition.roundColor = UIColor.black
        
        return transition
    }
    
    //метод отработки передачи данных
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //если был отработано двойное нажатие на главный постер фильма
        if segue.identifier == "DoubleTapFullPictures" {
            guard let destVC = segue.destination as? PosterFullViewController else {return}
            guard let id = choosedItem?.id else {return}
            
            destVC.getData(idImage: id)
            destVC.transitioningDelegate = self
            destVC.modalPresentationStyle = .custom
        }
        
        //нажата была кнопка показать все скриншоты
        if segue.identifier == "FilmPicsSegue" {
            
            guard let filmPicsVC = segue.destination as? FilmPicsViewController else {return}
            guard let id = choosedItem?.id else {return}
            
            filmPicsVC.getData(item: id)
        }
        
        //был выбран скриншот непосредственно из коллекции и его дальнейшое отображение отдельно индивидуально
        if segue.identifier == "ScreenshotFullPick" {
            
            guard let fullPicVC = segue.destination as? FullPicViewController else {return}
            
            guard let fullPicImage = fullPicImage else {return}
            fullPicVC.getData(image: fullPicImage)
        }
    }
    
}

extension DetailFilmViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return choosedItem?.screenshots.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = framesMovieCollectionView.dequeueReusableCell(withReuseIdentifier: "DetailFilmCell", for: indexPath) as? DetailFilmCollectionViewCell else {return UICollectionViewCell()}
        cell.DetailFilmImages.layer.cornerRadius = 15
        cell.DetailFilmImages.image = UIImage(named: choosedItem?.screenshots[indexPath.row] ?? "")
        
        guard let url = URL(string: adress + (choosedItem?.screenshots[indexPath.row] ?? "")) else { return cell}
        
        urlService.getSetPoster(withUrl: url) { image in
            cell.DetailFilmImages.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let url = URL(string: adress + (choosedItem?.screenshots[indexPath.row] ?? "")) else { return }
        
        //сохранение локально картинки для последующей передачи ее через сегвей
        urlService.getSetPoster(withUrl: url) { image in
            self.fullPicImage = image
        }
        
        self.performSegue(withIdentifier: "ScreenshotFullPick", sender: Any?.self)
    }
    
    
}
