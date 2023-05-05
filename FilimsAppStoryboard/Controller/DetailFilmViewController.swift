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
    
    @IBOutlet weak var allScreensButton: UIButton!
    var tapTouched: Bool = false
    
    var idFilm: Int?
    var fullPicImage: UIImage?
    
    var delegate: DetailFilmVCDelegate?
    
    var arrayImage: [UIImage?] = [UIImage(named: "1"), UIImage(named: "2"), UIImage(named: "3"), UIImage(named: "4"), UIImage(named: "5"), UIImage(named: "6"), ]
    
    var transition: RoundingTransition = RoundingTransition()
    
    let model = Model()
    
    var choosedItem: FilmObject?
    
    let adress: String = "https://image.tmdb.org/t/p/w500"
    let urlService = URLService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allScreensButton.layer.cornerRadius = 0
        allScreensButton.backgroundColor = .black.withAlphaComponent(0.6)
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(toggleLike))
        
        isLikeIcon.layer.opacity = 0.75
        isLikeIcon.isUserInteractionEnabled = true
        isLikeIcon.addGestureRecognizer(tap)
        
        DispatchQueue.main.async {
            
            guard let unwrData = self.choosedItem, let url = URL(string: self.adress + unwrData.filmPic) else {
                return
            }
            
            self.urlService.getSetPoster(withUrl: url) { image in
                self.filmPoster.image = image
            }
            
            self.filmTitleLabel.text = self.choosedItem?.filmTitle
            self.releaseYearLabel.text = "Release: \(String(self.choosedItem?.filmYear ?? 0000))"
            self.ratingLabel.text = "Rating \(String(self.choosedItem?.filmRating ?? 0))"
            self.descriptionLablel.text = self.choosedItem?.about ?? ""
            
            self.model.checkLikeFilm(id: self.choosedItem?.id ?? 0) ? (self.isLikeIcon.tintColor = .red) : (self.isLikeIcon.tintColor = .gray)
        }
        
        
        framesMovieCollectionView.delegate = self
        framesMovieCollectionView.dataSource = self
        
        storyboardTapGesture.addTarget(self, action: #selector(tapGestureAction(_ :)))
        
        DispatchQueue.main.async {
            self.framesMovieCollectionView.reloadData()
        }
    }
    
    
    @IBAction func openAllScreenshots(_ sender: Any) {
        
        
        
    }
    
    @objc func toggleLike() {
        guard let id = choosedItem?.id else {return}
        
        model.toggleLike(id: id)
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

        
        tapTouched = true
//        self.performSegue(withIdentifier: "DoubleTapFullPictures", sender: Any?.self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DoubleTapFullPictures" {
            guard let destVC = segue.destination as? PosterFullViewController else {return}
            guard let id = choosedItem?.id else {return}
            
            destVC.getData(idImage: id)
    //        tapTouched == true ? destVC.getData(idImage: id) : destVC.getData(idImage: idFilm ?? 1)
            tapTouched = false
            destVC.transitioningDelegate = self
            destVC.modalPresentationStyle = .custom
        }
        
        if segue.identifier == "FilmPicsSegue" {
            
            guard let filmPicsVC = segue.destination as? FilmPicsViewController else {return}
            guard let id = choosedItem?.id else {return}
            
            filmPicsVC.getData(item: id)
        }
        
        if segue.identifier == "ScreenshotFullPick" {
            
            guard let fullPicVC = segue.destination as? FullPicViewController else {return}
            
            guard let fullPicImage = fullPicImage else {return}
            fullPicVC.getData(image: fullPicImage)
        }
    }
    
}

extension DetailFilmViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return choosedItem?.screenshots.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = framesMovieCollectionView.dequeueReusableCell(withReuseIdentifier: "DetailFilmCell", for: indexPath) as? DetailFilmCollectionViewCell else {return UICollectionViewCell()}
        cell.DetailFilmImages.layer.cornerRadius = 15
        cell.DetailFilmImages.image = UIImage(named: choosedItem?.screenshots[indexPath.row] ?? "")
//        cell.data = self.choosedItem?.screenshots[indexPath.item]
        
        guard let url = URL(string: adress + (choosedItem?.screenshots[indexPath.row] ?? "")) else { return cell}
        
        urlService.getSetPoster(withUrl: url) { image in
            cell.DetailFilmImages.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let url = URL(string: adress + (choosedItem?.screenshots[indexPath.row] ?? "")) else { return }
        
        urlService.getSetPoster(withUrl: url) { image in
            self.fullPicImage = image
        }
        
        self.performSegue(withIdentifier: "ScreenshotFullPick", sender: Any?.self)
    }
    
    
}
