//
//  FavoriteFilmsViewController.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/02/23.
//

import UIKit


class FavoriteFilmsViewController: UIViewController {
    
    //оутлет коллекции со сториборд
    @IBOutlet weak var collectionView: UICollectionView!
    
    //модель данных
    let model = Model()
    
    //id для передачи его в вью подробнее о фильме
    var detailedFilmIndex: Int?
    
    //делегат для главной страницы
    var delegate: FavoriteVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let xibCell = UINib(nibName: "FavoriteCollectionViewCell", bundle: nil)
        collectionView.register(xibCell, forCellWithReuseIdentifier: "FavoriteCell")
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}

extension FavoriteFilmsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return model.likedFilms?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        //добавление внешнего вида для элементов
        cell.favoriteImage.layer.cornerRadius = 5
        cell.favoriteYearRelease.font = UIFont.italicSystemFont(ofSize: 21)
        cell.viewBelowRating.layer.cornerRadius = 10
        cell.likeImage.layer.opacity = 0.75
        
        //подключение кастомного нажаатия для сердечка избранного и передачи id
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapOnLikeImage))
        cell.likeImage.isUserInteractionEnabled = true
        cell.likeImage.tag = model.likedFilms?[indexPath.row].id ?? 0
        cell.likeImage.addGestureRecognizer(tap)
        
        cell.data = model.likedFilms?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        detailedFilmIndex = model.likedFilms?[indexPath.row].id
        
        //метод отображения страницы о фильме
        performSegue(withIdentifier: "showDetailFromFavotite", sender: nil)
        
    }
    
    //метод для передачи данных через сегвей
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showDetailFromFavotite" {
            let detailVC = segue.destination as! DetailFilmViewController
            detailVC.getData(item: detailedFilmIndex ?? 0)
            detailVC.delegate = self
        }
    }
    
    //отработка кастомного метода по нажатию на сердечко избранных и отработки метода в модели данных
    @objc func tapOnLikeImage(sender: UITapGestureRecognizer){
        let id = sender.view?.tag
        
        guard let id = id else {return}
        
        model.toggleLike(id: id)
        
        delegate?.updateData()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    
}

extension FavoriteFilmsViewController: DetailFilmVCDelegate {
    
    func updateData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
}
