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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private(set) var gallerys = [Gallery]()
    private var webService = WebService()
    
    var filteredGallerys: [Gallery]?
    var searchText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        galleryCollectionView.register(UINib(nibName: Constant.cellReuseId, bundle: nil), forCellWithReuseIdentifier: Constant.cellReuseId)
    }
    
    func populateGalleries() {
        guard let searchText = self.searchText else {
            return
        }
        
        self.webService.loadGalleryBySearch(searchText, Constant.clientID) { [weak self] response in
            self?.gallerys = response
            self?.galleryCollectionView.reloadData()
        }
    }
}

extension GalleryViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gallerys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.cellReuseId, for: indexPath) as? PhotoCollectionViewCell {
            cell.galleryTitle.text = self.gallerys[indexPath.row].title
        
            let imageLink = self.gallerys[indexPath.row].imageLink
            self.webService.loadImageFromUrl(imageLink) { (image, error) in
                DispatchQueue.main.async {
                    if let image = image, error == nil {
                        cell.photoImageView.image = image
                    }
                }
                
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 50
        let collectionViewSize = collectionView.frame.size.width - padding

        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
        
        
    }
}

extension GalleryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        populateGalleries()
        self.gallerySearchBar.resignFirstResponder()
    }
}

