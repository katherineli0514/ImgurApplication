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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImage()
        self.navigationItem.title = galleryTitle
    }
    
    func loadImage() {
        self.webService.loadImageFromUrl(imageLink) { [weak self] (image, error) in
            DispatchQueue.main.async {
                if let image = image, error == nil {
                    self?.imageView.image = image
                }
            }
        }
    }
}
