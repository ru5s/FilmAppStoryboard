//
//  MainViewController.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/02/23.
//

import UIKit

class MainViewController: UIViewController {
    
    //add outlet to collection view
    @IBOutlet weak var collectioView: UICollectionView!
    
    //add search bar
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectioView.delegate = self
        collectioView.dataSource = self
        
        let xibCell = UINib(nibName: "FilmCollectionViewCell", bundle: nil)
        
        collectioView.register(xibCell, forCellWithReuseIdentifier: "FilmCell")

        searchBar.delegate = self
        collectioView.reloadData()
        
        
    }
    


}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilmCell", for: indexPath) as? FilmCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.posterPreviewImageView.image = UIImage(named: testArray[indexPath.row].testPic!)
        cell.posterPreviewImageView.layer.cornerRadius = 5
        cell.filmTitleLabel.text = testArray[indexPath.row].testTitle
        cell.releaseYearLabel.text = testArray[indexPath.row].testYear
        cell.releaseYearLabel.font = UIFont.italicSystemFont(ofSize: 21)
        cell.ratingLabel.text = testArray[indexPath.row].testRating
        cell.viewBelowRating.layer.cornerRadius = 10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let detailFilmPage = storyboard.instantiateViewController(withIdentifier: "DetailFilm") as? DetailFilmViewController else {
            print("id not set")
            return
        }
        detailFilmPage.generalImageIndex = indexPath.row
        detailFilmPage.recievedIndex = indexPath.row
        navigationController?.pushViewController(detailFilmPage, animated: true)
        
    }
    
    
}

extension MainViewController: UISearchBarDelegate{
    
}
