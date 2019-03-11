//
//  GalleryListViewModel.swift
//  ImgurApplication
//
//  Created by Katherine Li on 3/6/19.
//  Copyright © 2019 Katherine Li. All rights reserved.
//

import Foundation

class GalleryListViewModel {
    
    private(set) var galleryViewModels = [GalleryViewModel]()
    private var webService: WebService
    
    init(_ webService: WebService) {
        self.webService = webService
        populateGalleries()
    }
    
    func populateGalleries() {
        
    }
}
