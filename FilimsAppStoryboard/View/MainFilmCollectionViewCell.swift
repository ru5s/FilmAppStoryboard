//
//  FilmCollectionViewCell.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 08/02/23.
//

import UIKit

class MainFilmCollectionViewCell: UICollectionViewCell {
    
    var data: Item? {
        didSet {
            
            guard data != nil else {
                return
            }
            
            posterPreviewImageView.image = UIImage(named: data?.testPic ?? "1")
            filmTitleLabel.text = data?.testTitle
            releaseYearLabel.text = String(data?.testYear ?? 0)
            ratingLabel.text = String(data?.testRating ?? 0)
            data?.isLiked ?? false ? (likeImage.tintColor = .red) : (likeImage.tintColor = .gray)
            
        }
    }
    
    @IBOutlet weak var likeImage: UIImageView!
    
    
    @IBOutlet weak var posterPreviewImageView: UIImageView!
    
    @IBOutlet weak var filmTitleLabel: UILabel!
    
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var viewBelowRating: UIView!
}
