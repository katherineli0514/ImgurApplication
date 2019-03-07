//
//  GalleryViewController.swift
//  ImgurApplication
//
//  Created by Katherine Li on 3/6/19.
//  Copyright © 2019 Katherine Li. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet weak var gallerySearchBar: UISearchBar!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

extension GalleryViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    }
}

