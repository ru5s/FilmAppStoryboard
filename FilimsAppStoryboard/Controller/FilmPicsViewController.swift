//
//  FilmPicsViewController.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/02/23.
//

import UIKit

class FilmPicsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var label: UILabel!
    
    let model = Model()
    var choosedItem: FilmObject?
    let urlService = URLService()
    let adress: String = "https://image.tmdb.org/t/p/w500/"
    
    var fullPicImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        let countImage = choosedItem?.screenshots.count
        label.text = "All screens - " + (countImage?.formatted() ?? "")
    }
    
    func getData(item: Int) {
        let predicate = NSPredicate(format: "id == \(item)")
        choosedItem = model.filmObjects?.filter(predicate).first
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "FullPickView" {
            
            guard let fullPicVC = segue.destination as? FullPicViewController else {return}
            
            guard let fullPicImage = fullPicImage else {return}
            fullPicVC.getData(image: fullPicImage)
        }
    }
    
}

extension FilmPicsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        choosedItem?.screenshots.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilmPicsCell", for: indexPath) as? FilmPicsCollectionViewCell else {return UICollectionViewCell()}
        
        guard let url = URL(string: adress + (choosedItem?.screenshots[indexPath.row] ?? "")) else { return cell}
        
        urlService.getSetPoster(withUrl: url) { image in
            cell.filmPicsImage.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let url = URL(string: adress + (choosedItem?.screenshots[indexPath.row] ?? "")) else { return }
        
        urlService.getSetPoster(withUrl: url) { image in
            self.fullPicImage = image
        }
        
        self.performSegue(withIdentifier: "FullPickView", sender: Any?.self)
        
    }
    
}
