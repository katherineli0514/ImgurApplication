//
//  GalleryModel.swift
//  ImgurApplication
//
//  Created by Katherine Li on 3/6/19.
//  Copyright © 2019 Katherine Li. All rights reserved.
//

import Foundation
import UIKit

class Gallery {
    
    var imageLink: String
    var title: String
    var image: UIImage?
    var gifLink: String?
    
    init(_ imageLink: String, _ title: String, _ image: UIImage? = nil, _ gifLink: String? = nil) {
        self.imageLink = imageLink
        self.title = title
        self.image = image
        self.gifLink = gifLink
    }
    
}
