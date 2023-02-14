//
//  FilmCollectionViewCell.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 08/02/23.
//

import UIKit

class FilmCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterPreviewImageView: UIImageView!
    
    @IBOutlet weak var filmTitleLabel: UILabel!
    
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var viewBelowRating: UIView!
}
