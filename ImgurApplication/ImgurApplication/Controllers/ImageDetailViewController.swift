//
//  ImageDetailViewController.swift
//  ImgurApplication
//
//  Created by Katherine Li on 3/12/19.
//  Copyright © 2019 Katherine Li. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var imageLink = ""
    var galleryTitle = ""
    var webService = WebService()
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = galleryTitle
        self.displayImage()
    }
    
    func displayImage() {
        self.imageView.image = image
    }
}
