//
//  MainViewController.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/02/23.
//

import UIKit

protocol MainVCDelegate {
    func removeFromFavorite(id: Int)
}

protocol DetailFilmVCDelegate {
    func toggleLike(id: Int)
    func updateData()
}

class MainViewController: UIViewController {
    
    //add outlet to collection view
    @IBOutlet weak var collectioView: UICollectionView!
    
    //add search bar
    var searchController = UISearchController()
    
    var model = Model()
    
    var detailedFilmIndex: Int?
    
    @IBOutlet weak var sortBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.newTestArray = model.testArray
        model.ratingSort()
        
        collectioView.delegate = self
        collectioView.dataSource = self
        
        let xibCell = UINib(nibName: "MainFilmCollectionViewCell", bundle: nil)
        collectioView.register(xibCell, forCellWithReuseIdentifier: "FilmCell")

        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Find Your Film"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        collectioView.reloadData()
    }
    
    @IBAction func sortBtnAction(_ sender: Any) {
        model.sortAscending ? (sortBtn.image = UIImage(systemName: "arrow.up")) : (sortBtn.image = UIImage(systemName: "arrow.down"))
        model.sortAscending.toggle()
        model.ratingSort()
        
        collectioView.reloadData()
    }
}

extension MainViewController: MainVCDelegate {
    
    func removeFromFavorite(id: Int) {
        model.removeFromFavorite(id: id)
        collectioView.reloadData()
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return model.newTestArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilmCell", for: indexPath) as? MainFilmCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.posterPreviewImageView.layer.cornerRadius = 5
        cell.releaseYearLabel.font = UIFont.italicSystemFont(ofSize: 21)
        cell.viewBelowRating.layer.cornerRadius = 10
        cell.likeImage.layer.opacity = 0.75
        
        cell.data = self.model.newTestArray[indexPath.item]
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapOnLikeImage))
        cell.likeImage.isUserInteractionEnabled = true
        cell.likeImage.tag = indexPath.row
        cell.likeImage.addGestureRecognizer(tap)
        
        return cell
    }
    
    @objc func tapOnLikeImage(sender: UITapGestureRecognizer){
        let index = sender.view?.tag
        model.toggleLike(index: index ?? 0)
        collectioView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        detailedFilmIndex = indexPath.row
        performSegue(withIdentifier: "DetailFilmSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "likeData" {
            model.showLikedItems()
            
            let favVC = segue.destination as! FavoriteFilmsViewController
            favVC.showItem(sender: model.likedArrayItem)
            favVC.delegate = self
        }

        if segue.identifier == "DetailFilmSegue" {
            let detailVC = segue.destination as! DetailFilmViewController
            detailVC.getData(item: model.testArray[detailedFilmIndex ?? 0])
            detailVC.delegate = self
        }
    }
    
}

extension MainViewController: DetailFilmVCDelegate {
    func toggleLike(id: Int) {
        model.toggleLike(index: id)
        
        collectioView.reloadData()
    }
    
    func updateData(){
        collectioView.reloadData()
    }
}


extension MainViewController: UISearchBarDelegate{
    
}
