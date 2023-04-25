//
//  PosterFullViewController.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 22/02/23.
//

import UIKit

class PosterFullViewController: UIViewController{
    
    @IBOutlet weak var posterFullView: UIImageView!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    let model = Model()
    
    var choosedPoster: FilmObject?
    
    let urlServise = URLService()
    
    let adress = "https://image.tmdb.org/t/p/w500/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let unwrData =  choosedPoster?.filmPic, let url = URL(string: adress + unwrData) else {
            return
        }
        urlServise.getSetPoster(withUrl: url) { image in
            self.posterFullView.image = image
        }
        
        closeBtn.layer.cornerRadius = closeBtn.frame.height / 2
    }
    

    @IBAction func closeBtnTapped(_ sender: UIButton) {

        dismiss(animated: true, completion: nil)
        
    }
    
    func getData (idImage: Int) {
        choosedPoster = model.filmObjects?.filter({ item in
            item.id == idImage
        }).first
        
    }
    
}
