//
//  GalleryViewController.swift
//  ImgurApplication
//
//  Created by Katherine Li on 3/6/19.
//  Copyright © 2019 Katherine Li. All rights reserved.
//

import UIKit

enum Constant {
    static let cellReuseId = "PhotoCollectionViewCell"
}

class GalleryViewController: UIViewController {

    @IBOutlet weak var gallerySearchBar: UISearchBar!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    private var webService = WebService()
    private var galleryListViewModel: GalleryListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        galleryCollectionView.register(UINib(nibName: Constant.cellReuseId, bundle: nil), forCellWithReuseIdentifier: Constant.cellReuseId)
        
        self.galleryListViewModel = GalleryListViewModel(webService)
        webService.loadGalleryBySearch("cats", "126701cd8332f32", completion: { gallerys in
            let gallerys = gallerys
            print(gallerys)
        })
    }


}

extension GalleryViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.cellReuseId, for: indexPath) as? PhotoCollectionViewCell {
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

