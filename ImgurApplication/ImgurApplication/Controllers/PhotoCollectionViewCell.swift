//
//  PhotoCollectionViewCell.swift
//  ImgurApplication
//
//  Created by Katherine Li on 3/6/19.
//  Copyright © 2019 Katherine Li. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var galleryTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    deinit {
        self.photoImageView.image = nil
    }

}
