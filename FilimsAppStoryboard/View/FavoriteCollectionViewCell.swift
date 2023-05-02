//
//  FavoriteCollectionViewCell.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/03/23.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    let urlService = URLService()
    
    let adress: String = "https://image.tmdb.org/t/p/w500/"
    
    var data: IsLikedFilmObjects? {
        didSet {
            guard let unwrData = data, let url = URL(string: adress + unwrData.filmPic) else {
                return
            }
            urlService.getSetPoster(withUrl: url) { image in
                self.favoriteImage.image = image
            }
            favoriteTitle.text = data?.filmTitle
            favoriteYearRelease.text = String(data?.filmYear ?? 0000)
            favoriteRating.text = String(data?.filmRating ?? 0)
            
            data?.isLiked ?? false ? (likeImage.tintColor = .red) : (likeImage.tintColor = .gray)
        }
    }
    
    @IBOutlet weak var likeImage: UIImageView!
    
    @IBOutlet weak var favoriteImage: UIImageView!
    
    @IBOutlet weak var favoriteTitle: UILabel!
    
    @IBOutlet weak var favoriteYearRelease: UILabel!
    
    @IBOutlet weak var favoriteRating: UILabel!
    
    @IBOutlet weak var viewBelowRating: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
