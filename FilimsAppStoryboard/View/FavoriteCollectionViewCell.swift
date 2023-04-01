//
//  FavoriteCollectionViewCell.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/03/23.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    var data: FilmObject? {
        didSet {
            guard data != nil else {
                return
            }
            
            favoriteImage.image = UIImage(named: data?.testPic ?? "1")
            favoriteTitle.text = data?.testTitle
            favoriteYearRelease.text = data?.testYear ?? "0"
            favoriteRating.text = String(data?.testRating ?? 0)
            
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
    
    
    @IBAction func unwindToPresentingViewController(segue:UIStoryboardSegue){
        if segue.identifier == "likeData" {
            if let VC2 = segue.source as? MainViewController {
                VC2.removeFromFavorite(id: 0)
            }
            
        }
    }
}
