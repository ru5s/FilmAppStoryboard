//
//  PosterFullViewController.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 22/02/23.
//

import UIKit

class PosterFullViewController: UIViewController{
    
    //оутлеты со сториборд
    @IBOutlet weak var posterFullView: UIImageView!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    //модель данных
    let model = Model()
    //выбранный фильм с постером
    var choosedPoster: FilmObject?
    
    //менеджер работы с апи
    let urlServise = URLService()
    //общая часть url
    let adress = "https://image.tmdb.org/t/p/w500/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let unwrData =  choosedPoster?.filmPic, let url = URL(string: adress + unwrData) else {
            return
        }
        //получение картинки
        urlServise.getSetPoster(withUrl: url) { image in
            self.posterFullView.image = image
        }
        
        closeBtn.layer.cornerRadius = closeBtn.frame.height / 2
    }
    
    //кнопка отмены отображения вью
    @IBAction func closeBtnTapped(_ sender: UIButton) {

        dismiss(animated: true, completion: nil)
        
    }
    //получение id фильма
    func getData (idImage: Int) {
        choosedPoster = model.filmObjects?.filter({ item in
            item.id == idImage
        }).first
        
    }
    
}
