//
//  DetailFilmViewController.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/02/23.
//

import UIKit

class DetailFilmViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var filmPoster: UIImageView!
    
    @IBOutlet weak var filmTitleLabel: UILabel!
    
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var framesMovieCollectionView: UICollectionView!
    
    @IBOutlet weak var descriptionLablel: UITextView!
    
    @IBOutlet var storyboardTapGesture: UITapGestureRecognizer!
    var posterString: String!
    
    var recievedIndex: Int = Int()
    var generalImageIndex: Int = Int()
    var local: Bool = false
    
    var arrayImage: [UIImage?] = [UIImage(named: "1"), UIImage(named: "2"), UIImage(named: "3"), UIImage(named: "4"), UIImage(named: "5"), UIImage(named: "6"), ]
    
    var transition: RoundingTransition = RoundingTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filmTitleLabel.text = testArray[recievedIndex].testTitle
        releaseYearLabel.text = "Release: \(String(describing: testArray[recievedIndex].testYear))"
        ratingLabel.text = "Rating \(String(describing: testArray[recievedIndex].testRating))"
        filmPoster.image = UIImage(named: testArray[recievedIndex].testPic ?? "2")
        
        framesMovieCollectionView.delegate = self
        framesMovieCollectionView.dataSource = self
        
        framesMovieCollectionView.reloadData()
        storyboardTapGesture.name = posterString
        storyboardTapGesture.addTarget(self, action: #selector(tapGestureAction(_ :)))
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionProfile = .show
        transition.start = filmPoster.center
        transition.roundColor = UIColor.black
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transition.transitionProfile = .cancel
        transition.time = 1.0
        transition.start = filmPoster.center
        transition.roundColor = UIColor.black
        
        return transition
    }
    
    
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        local = false
        if sender.state == .ended{
            self.performSegue(withIdentifier: "DoubleTapFullPictures", sender: Any?.self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? PosterFullViewController else {return}
        
        local ? (destVC.detailedIndexPath = recievedIndex) : (destVC.detailedIndexPath = generalImageIndex)
        
        destVC.transitioningDelegate = self
        destVC.modalPresentationStyle = .custom
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        local = true
        recievedIndex = indexPath.row
        self.performSegue(withIdentifier: "DoubleTapFullPictures", sender: Any?.self)
    }
    
    
}
