//
//  PosterFullViewController.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 22/02/23.
//

import UIKit

protocol PosterFullProtocol {
    func setAllData(argument: String)
}

class PosterFullViewController: UIViewController, PosterFullProtocol {
    
    @IBOutlet weak var posterFullView: UIImageView!
    var poster: String = "1"
    
    @IBOutlet weak var closeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posterFullView.image = UIImage(named: poster)
    }
    
    func setAllData(argument: String){
        poster = argument
        
    }
    

    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
