//
//  FavoriteCollectionViewCell.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/03/23.
//

import UIKit

//кастомная ячейка, которая имеет свой xib файл с макетом
class FavoriteCollectionViewCell: UICollectionViewCell {
    
    //менеджер работы с апи
    let urlService = URLService()
    let adress: String = "https://image.tmdb.org/t/p/w500/"
    
    //передача данных сразу в элементы
    var data: IsLikedFilmObjects? {
        didSet {
            
            //проверка на то что дата пришла и то что url полностью собран
            guard let unwrData = data, let url = URL(string: adress + unwrData.filmPic) else {
                return
            }
            
            //получаем постер к фильму
            urlService.getSetPoster(withUrl: url) { image in
                self.favoriteImage.image = image
            }
            //заполняем элементы ячейки
            favoriteTitle.text = data?.filmTitle
            favoriteYearRelease.text = String(data?.filmYear ?? 0000)
            favoriteRating.text = String(data?.filmRating ?? 0)
            
            data?.isLiked ?? false ? (likeImage.tintColor = .red) : (likeImage.tintColor = .gray)
        }
    }
    
    //оутлеты с xib ячейки FavoriteCollectionViewCell
    @IBOutlet weak var likeImage: UIImageView!
    
    @IBOutlet weak var favoriteImage: UIImageView!
    
    @IBOutlet weak var favoriteTitle: UILabel!
    
    @IBOutlet weak var favoriteYearRelease: UILabel!
    
    @IBOutlet weak var favoriteRating: UILabel!
    
    @IBOutlet weak var viewBelowRating: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
