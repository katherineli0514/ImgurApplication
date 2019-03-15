//
//  ImageDetailViewController.swift
//  ImgurApplication
//
//  Created by Katherine Li on 3/12/19.
//  Copyright © 2019 Katherine Li. All rights reserved.
//

import UIKit
import AVKit

class ImageDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var imageLink = ""
    var galleryTitle = ""
    var webService = WebService()
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = galleryTitle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.displayImageDetail()
    }
    
    func displayImageDetail() {
        if let _ = self.image {
            displayImage()
        } else {
            playVideo()
        }
    }
    
    func displayImage() {
        self.imageView.image = image
    }
    
    func playVideo() {
        if let videoURL = URL(string: imageLink) {
            let player = AVPlayer(url: videoURL)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.view.bounds
            self.view.layer.addSublayer(playerLayer)
            player.play()
        }
    }
}
