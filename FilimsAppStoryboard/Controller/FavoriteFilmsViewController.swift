//
//  FavoriteFilmsViewController.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/02/23.
//

import UIKit


class FavoriteFilmsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var likedArray: [Item] = []
    
    var delegate: MainVCDelegate = MainViewController()
    
    var likedId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let xibCell = UINib(nibName: "FavoriteCollectionViewCell", bundle: nil)
        collectionView.register(xibCell, forCellWithReuseIdentifier: "FavoriteCell")
        
        collectionView.reloadData()
        
    }
    
    
    func showItem(sender: [Item]){
        likedArray = sender
    }
    
}

extension FavoriteFilmsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard likedArray.count < 0 else {
            return likedArray.count
        }
        return 0
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
        cell.likeImage.tag = indexPath.row
        cell.likeImage.addGestureRecognizer(tap)
        
        guard likedArray.count < 0 else {
            
            cell.data = likedArray[indexPath.item]
            
            return cell
        }
        
        return cell
    }
    
    @objc func tapOnLikeImage(sender: UITapGestureRecognizer){
        let index = sender.view?.tag
        
        likedId = likedArray[index ?? 0].id
        
        delegate.removeFromFavorite(id: likedId ?? 0)
        
        likedArray.remove(at: index ?? 0)
        
        collectionView.reloadData()
    }
    
    
    
}

