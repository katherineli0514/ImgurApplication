//
//  GalleryModel.swift
//  ImgurApplication
//
//  Created by Katherine Li on 3/6/19.
//  Copyright © 2019 Katherine Li. All rights reserved.
//

import Foundation

class Gallery {
    
    var imageLink: String
    var title: String
    
    init(_ imageLink: String, _ title: String) {
        self.imageLink = imageLink
        self.title = title
    }
    
}
