//
//  DetailFilmViewController.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/02/23.
//

import UIKit

class DetailFilmViewController: UIViewController {
    
    @IBOutlet weak var filmPoster: UIImageView!
    var posterString: String!
    
    @IBOutlet weak var filmTitleLabel: UILabel!
    var titleLabelString: String!
    
    @IBOutlet weak var releaseYearLabel: UILabel!
    var yearLabelString: String!
    
    @IBOutlet weak var ratingLabel: UILabel!
    var ratingLabelString: String!
    
    @IBOutlet weak var framesMovieCollectionView: UICollectionView!
    
    @IBOutlet weak var descriptionLablel: UITextView!
    
    @IBOutlet var storyboardTapGesture: UITapGestureRecognizer!
    
    var arrayImage: [UIImage?] = [UIImage(named: "1"), UIImage(named: "2"), UIImage(named: "3"), UIImage(named: "4"), UIImage(named: "5"), UIImage(named: "6"), ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        filmTitleLabel.text = titleLabelString
        releaseYearLabel.text = "Release: \(String(yearLabelString))"
        ratingLabel.text = "Rating \(String(ratingLabelString))"
        filmPoster.image = UIImage(named: posterString)

        framesMovieCollectionView.delegate = self
        framesMovieCollectionView.dataSource = self
        
        framesMovieCollectionView.reloadData()
        storyboardTapGesture.name = posterString
        storyboardTapGesture.addTarget(self, action: #selector(tapGestureAction(_ :)))
    }
    
    func setAllData(array: [TestModel], index : IndexPath){
        titleLabelString = array[index.row].testTitle
        yearLabelString = array[index.row].testYear
        ratingLabelString = array[index.row].testRating
        posterString = array[index.row].testPic
    }

    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        
        if sender.state == .ended{
            let fullPosterView = storyboard?.instantiateViewController(withIdentifier: "DoubleTapFullPictures") as! PosterFullViewController
            
            fullPosterView.setAllData(argument: sender.name!)
            
        }
        
        
    }
}

extension DetailFilmViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = framesMovieCollectionView.dequeueReusableCell(withReuseIdentifier: "DetailFilmCell", for: indexPath) as? DetailFilmCollectionViewCell else {return UICollectionViewCell()}
        cell.DetailFilmImages.layer.cornerRadius = 15
        cell.DetailFilmImages.image = arrayImage[indexPath.row]
        
        return cell
    }
    
    
}
