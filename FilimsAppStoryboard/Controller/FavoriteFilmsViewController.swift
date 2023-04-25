//
//  FavoriteFilmsViewController.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/02/23.
//

import UIKit


class FavoriteFilmsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let model = Model()
    
    var detailedFilmIndex: Int?
    var delegate: FavoriteVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.showLikedItems()
        
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
        
        return model.likedArrayItem?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.favoriteImage.layer.cornerRadius = 5
        cell.favoriteYearRelease.font = UIFont.italicSystemFont(ofSize: 21)
        cell.viewBelowRating.layer.cornerRadius = 10
        cell.likeImage.layer.opacity = 0.75
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapOnLikeImage))
        cell.likeImage.isUserInteractionEnabled = true
        cell.likeImage.tag = model.likedArrayItem?[indexPath.row].id ?? 0
        cell.likeImage.addGestureRecognizer(tap)
        
        cell.data = model.likedArrayItem?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        detailedFilmIndex = model.likedArrayItem?[indexPath.row].id
        
        performSegue(withIdentifier: "showDetailFromFavotite", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showDetailFromFavotite" {
            let detailVC = segue.destination as! DetailFilmViewController
            detailVC.getData(item: detailedFilmIndex ?? 0)
            detailVC.delegate = self
        }
    }
    
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
