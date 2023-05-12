//
//  FullPicViewController.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 07/02/23.
//

import UIKit

class FullPicViewController: UIViewController {
    
    @IBOutlet weak var fullPicImage: UIImageView!
    
    //избранное изображение
    var choosedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //передача изображения в оутлет
        fullPicImage.image = choosedImage
        
    }
    
    //метод получения изображения с предыдущего вью
    func getData(image: UIImage) {
        choosedImage = image
    }

}
