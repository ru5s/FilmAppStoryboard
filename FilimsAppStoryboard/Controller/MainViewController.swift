//
//  MainViewController.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/02/23.
//

import UIKit
//import RealmSwift

//protocol MainVCDelegate {
//    func removeFromFavorite(id: Int)
//}

protocol DetailFilmVCDelegate {
    func updateData()
}

protocol FavoriteVCDelegate {
    func updateData()
}

class MainViewController: UIViewController {
    
    //add outlet to collection view
    @IBOutlet weak var collectioView: UICollectionView!
    
    @IBOutlet weak var popularBtn: UIButton!
    
    @IBOutlet weak var topRatedBnt: UIButton!
    
    @IBOutlet weak var watchNowBtn: UIButton!
    //add search bar
    var searchController = UISearchController()
    
    var model = Model()
    
    var detailedFilmIndex: Int?
    
    @IBOutlet weak var sortBtn: UIBarButtonItem!
    
    let urlService = URLService()
    var page: Int = 9
    var typeMovie: RequestOptions = .allMovie
    
    let group = DispatchGroup()
    let thread = DispatchQueue(label: "com.filmAppStoryboard")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.arrayHelper = model.filmObjects
        collectioView.delegate = self
        collectioView.dataSource = self
        
        popularBtn.backgroundColor = .systemTeal
        popularBtn.layer.cornerRadius = 10
        topRatedBnt.backgroundColor = .systemGray2
        topRatedBnt.layer.cornerRadius = 10
        watchNowBtn.backgroundColor = .systemGray2
        watchNowBtn.layer.cornerRadius = 10
        
        
        urlService.dataRequest(page: page, requestOptions: typeMovie)
//        model.sortByType(type: typeMovie)
        
        let xibCell = UINib(nibName: "MainFilmCollectionViewCell", bundle: nil)
        collectioView.register(xibCell, forCellWithReuseIdentifier: "FilmCell")
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Find Your Film"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        collectioView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.model.screenshotsLink()
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.model.sortByType(type: self.typeMovie)
            self.collectioView.reloadData()
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        model.screenshotsLink()
        
    }
    
    @IBAction func sortBtnAction(_ sender: Any) {
        model.sortAscending ? (sortBtn.image = UIImage(systemName: "arrow.up")) : (sortBtn.image = UIImage(systemName: "arrow.down"))
        
        model.sortByType(type: typeMovie)
        model.sortAscending.toggle()
        
        model.ratingSort()
        
        collectioView.reloadData()
//        DispatchQueue.main.async {
//            self.collectioView.reloadData()
//
//        }
    }
    @IBAction func tappedPopular(_ sender: Any) {
        
        popularBtn.backgroundColor = .systemTeal
        topRatedBnt.backgroundColor = .systemGray2
        watchNowBtn.backgroundColor = .systemGray2
        
        
        typeMovie = .allMovie
        
        urlService.dataRequest(page: page, requestOptions: typeMovie)
        model.sortByType(type: typeMovie)
//        model.ratingSort()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.collectioView.reloadData()
            self.collectioView.setContentOffset(.zero, animated: true)
        }
    }
    
    @IBAction func tappedTopRated(_ sender: Any) {
        
        topRatedBnt.backgroundColor = .systemTeal
        popularBtn.backgroundColor = .systemGray2
        watchNowBtn.backgroundColor = .systemGray2
        
        typeMovie = .topRated
        
        urlService.dataRequest(page: page, requestOptions: typeMovie)
        model.sortByType(type: typeMovie)
//        model.ratingSort()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.collectioView.reloadData()
            self.collectioView.setContentOffset(.zero, animated: true)
        }
    }
    
    @IBAction func tappedWatchNow(_ sender: Any) {
        
        watchNowBtn.backgroundColor = .systemTeal
        topRatedBnt.backgroundColor = .systemGray2
        popularBtn.backgroundColor = .systemGray2
        
        typeMovie = .nowPlaying
        
        urlService.dataRequest(page: page, requestOptions: typeMovie)
        model.sortByType(type: typeMovie)
//        model.ratingSort()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.collectioView.reloadData()
            self.collectioView.setContentOffset(.zero, animated: true)
        }
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let filmObjectsCount = model.arrayHelper?.count else {
            return Int()
        }
        return filmObjectsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilmCell", for: indexPath) as? MainFilmCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.posterPreviewImageView.layer.cornerRadius = 5
        cell.releaseYearLabel.font = UIFont.italicSystemFont(ofSize: 21)
        cell.viewBelowRating.layer.cornerRadius = 10
        cell.likeImage.layer.opacity = 0.75
        
        cell.data = self.model.arrayHelper?[indexPath.item]
        
        model.checkLikeFilm(id: Int(model.arrayHelper?[indexPath.row].id ?? 0)) ? (cell.likeImage.tintColor = .red) : (cell.likeImage.tintColor = .gray)
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapOnLikeImage))
        cell.likeImage.isUserInteractionEnabled = true
        cell.likeImage.tag = model.arrayHelper?[indexPath.row].id ?? 0
        cell.likeImage.addGestureRecognizer(tap)
        
        return cell
    }
    
    
    
    @objc func tapOnLikeImage(sender: UITapGestureRecognizer){
        let id = sender.view?.tag
        
        guard let id = id else {return}
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.2) {
                sender.view?.tintColor == .red ? (sender.view?.tintColor = .gray) : (sender.view?.tintColor = .red)
            }
            
            self.model.toggleLike(id: id)

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        model.screenshotsLink()
        
        detailedFilmIndex = model.arrayHelper?[indexPath.row].id
        
        performSegue(withIdentifier: "DetailFilmSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "likeData" {
            model.showLikedItems()
            let favVC = segue.destination as! FavoriteFilmsViewController
            favVC.delegate = self
            
        }

        if segue.identifier == "DetailFilmSegue" {
            let detailVC = segue.destination as! DetailFilmViewController
            guard let detailedFilmIndex = detailedFilmIndex else {return}
            detailVC.getData(item: detailedFilmIndex)
            detailVC.delegate = self
        }
    }
    
}

extension MainViewController: DetailFilmVCDelegate, FavoriteVCDelegate {
    func updateData(){
        DispatchQueue.main.async {
            self.collectioView.reloadData()
        }
    }
}

extension MainViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.arrayHelper = model.filmObjects
        model.search(searchTextValue: searchText)
        
        if searchText.isEmpty {
            model.arrayHelper = model.filmObjects
            model.ratingSort()
        }
        
        DispatchQueue.main.async {
            self.collectioView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        model.arrayHelper = model.filmObjects
        
        if searchBar.text?.count == 0 {
            model.arrayHelper = model.filmObjects
            
            
            model.ratingSort()
        }
        
        model.ratingSort()
        
        DispatchQueue.main.async {
            self.collectioView.reloadData()
        }
    }
}
