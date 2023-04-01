//
//  DetailFilmViewController.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/02/23.
//

import UIKit
import RealmSwift

class DetailFilmViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var isLikeIcon: UIImageView!
    
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
    
    var delegate: DetailFilmVCDelegate?
    
    var arrayImage: [UIImage?] = [UIImage(named: "1"), UIImage(named: "2"), UIImage(named: "3"), UIImage(named: "4"), UIImage(named: "5"), UIImage(named: "6"), ]
    
    var transition: RoundingTransition = RoundingTransition()
    
    let model = Model()
    
    var choosedItem: FilmObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLikeIcon.layer.opacity = 0.75
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(toggleLike))
        isLikeIcon.isUserInteractionEnabled = true
        isLikeIcon.addGestureRecognizer(tap)
        
        filmTitleLabel.text = choosedItem?.testTitle
        releaseYearLabel.text = "Release: \(String(choosedItem?.testYear ?? "0"))"
        ratingLabel.text = "Rating \(String(choosedItem?.testRating ?? 0))"
        filmPoster.image = UIImage(named: choosedItem?.testPic ?? "1")
        
        choosedItem?.isLiked ?? false ? (isLikeIcon.tintColor = .red) : (isLikeIcon.tintColor = .gray)
        
        framesMovieCollectionView.delegate = self
        framesMovieCollectionView.dataSource = self
        
        storyboardTapGesture.name = posterString
        storyboardTapGesture.addTarget(self, action: #selector(tapGestureAction(_ :)))
        
        DispatchQueue.main.async {
            self.framesMovieCollectionView.reloadData()
        }
    }
    
    @objc func toggleLike() {
        model.toggleLike(index: choosedItem?.id ?? Int())
        choosedItem?.isLiked ?? false ? (isLikeIcon.tintColor = .red) : (isLikeIcon.tintColor = .gray)
        delegate?.updateData()
    }
    
    func getData(item: Int) {
        
        choosedItem = model.filmObjects?.where({ film in
            film.id == item
        }).first
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionProfile = .show
        transition.start = filmPoster.center
        transition.roundColor = UIColor.black
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionProfile = .cancel
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
        
        local ? (destVC.detailedIndexPath = recievedIndex) : (destVC.detailedIndexPath = choosedItem?.id ?? 0)
        local = false
        
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
