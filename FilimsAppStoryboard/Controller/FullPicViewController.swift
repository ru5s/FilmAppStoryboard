//
//  FullPicViewController.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/02/23.
//

import UIKit

class FullPicViewController: UIViewController {
    
    @IBOutlet weak var fullPicImage: UIImageView!
    var choosedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullPicImage.image = choosedImage
        // Do any additional setup after loading the view.
    }
    
    func getData(image: UIImage) {
        choosedImage = image
    }

}
