//
//  FilmCollectionViewCell.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 08/02/23.
//

import UIKit

class MainFilmCollectionViewCell: UICollectionViewCell {
    
    let urlServise = URLService()
    let adress = "https://image.tmdb.org/t/p/w500/"
    let model = Model()
    
    var data: FilmObject? {
        didSet {
            
            guard let unwrData =  data, let url = URL(string: adress + unwrData.filmPic) else {
                return
            }
            urlServise.getSetPoster(withUrl: url) { image in
                self.posterPreviewImageView.image = image
            }

            filmTitleLabel.text = data?.filmTitle
            releaseYearLabel.text = String(data?.filmYear ?? 0000)
            ratingLabel.text = String(data?.filmRating ?? 0)
//            data?.isLiked ?? false ? (likeImage.tintColor = .red) : (likeImage.tintColor = .gray)
            
            
        }
    }
    
    @IBOutlet weak var likeImage: UIImageView!
    
    @IBOutlet weak var posterPreviewImageView: UIImageView!
    
    @IBOutlet weak var filmTitleLabel: UILabel!
    
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var viewBelowRating: UIView!
}
