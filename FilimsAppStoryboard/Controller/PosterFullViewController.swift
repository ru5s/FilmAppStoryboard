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
    
    var detailedIndexPath: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posterFullView.image = UIImage(named: "2")
        closeBtn.layer.cornerRadius = closeBtn.frame.height / 2
    }
    

    @IBAction func closeBtnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
}
