//
//  FilmCollectionViewCell.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 08/02/23.
//

import UIKit

//кастомная ячейка, которая имеет свой xib файл с макетом
class MainFilmCollectionViewCell: UICollectionViewCell {
    
    //менеджер работы с апи
    let urlServise = URLService()
    let adress = "https://image.tmdb.org/t/p/w500/"
    
    //передача данных сразу в элементы
    var data: FilmObject? {
        didSet {
            
            //проверка на то что дата пришла и то что url полностью собран
            guard let unwrData =  data, let url = URL(string: adress + unwrData.filmPic) else {
                return
            }
            //получаем постер к фильму
            urlServise.getSetPoster(withUrl: url) { image in
                self.posterPreviewImageView.image = image
            }
            //заполняем элементы ячейки
            filmTitleLabel.text = data?.filmTitle
            releaseYearLabel.text = String(data?.filmYear ?? 0000)
            ratingLabel.text = String(data?.filmRating ?? 0)
        }
    }
    
    //оутлеты с xib ячейки MainFilmCollectionViewCell
    @IBOutlet weak var likeImage: UIImageView!
    
    @IBOutlet weak var posterPreviewImageView: UIImageView!
    
    @IBOutlet weak var filmTitleLabel: UILabel!
    
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var viewBelowRating: UIView!
}
