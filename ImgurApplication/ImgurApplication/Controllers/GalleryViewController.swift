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
    @IBOutlet weak var searchIconView: UIView!
    
    private(set) var gallerys = [Gallery]() {
        didSet {
            if gallerys.count == 0 {
                self.searchIconView.alpha = 1
            } else {
                self.searchIconView.alpha = 0
            }
        }
    }
    private var webService = WebService()
    
    var filteredGallerys: [Gallery]?
    var searchText: String?
    // Debouncer for 250 ms
    let debouncer = Debouncer(timeInterval: 0.25)
    var currentPage: Int = 1
    var visibleItems = [IndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        galleryCollectionView.register(UINib(nibName: Constant.cellReuseId, bundle: nil), forCellWithReuseIdentifier: Constant.cellReuseId)
    }
    
    func populateGalleries() {
        guard let searchText = self.searchText else {
            return
        }
        
        self.webService.loadGalleryBySearch(1, searchText, Constant.clientID) { [weak self] response in
            self?.gallerys = response
            self?.galleryCollectionView.reloadData()
        }
    }
    
    func fetchNextPage() {
        guard let searchText = self.searchText else {
            return
        }
        currentPage += 1
        
        // Depends on how many pages Imgur API has.
        if currentPage > 20 {
            return
        }
        self.webService.loadGalleryBySearch(currentPage, searchText, Constant.clientID) { [weak self] response in
            self?.gallerys.append(contentsOf: response)
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
            cell.galleryTitle.text = self.gallerys[indexPath.item].title
        
            let imageLink = self.gallerys[indexPath.item].imageLink
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

extension GalleryViewController: UICollectionViewDelegate {
    // Reload next page when user keeps scrolling from the bottom of collectionView
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y: Float = Float(offset.y + bounds.size.height - inset.bottom)
        let h: Float = Float(size.height)
        
        let reload_distance: Float = 50
        
        if y > h + reload_distance {
            self.fetchNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let imageDetailViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: Constant.imageDetailVCStoryBoardID) as? ImageDetailViewController {
            imageDetailViewController.imageLink = self.gallerys[indexPath.item].imageLink
            imageDetailViewController.galleryTitle = self.gallerys[indexPath.item].title
            self.navigationController?.pushViewController(imageDetailViewController, animated: true)
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            // Save the visible row position
            self.visibleItems = self.galleryCollectionView.indexPathsForVisibleItems
            context.viewController(forKey: UITransitionContextViewControllerKey.from)
        }, completion: { context in
            // Scroll to the saved position prior to screen rotate
            self.galleryCollectionView.scrollToItem(at: self.visibleItems[0], at: .top, animated: false) 
        })
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 25
        let collectionViewSize = collectionView.frame.size.width - padding
        var width: CGFloat = 0
        // Display 3 columns on landscape, 2 columes on portrait
        if UIDevice.current.orientation.isLandscape {
            width = collectionViewSize/3
        } else {
            width = collectionViewSize/2
        }
        return CGSize(width: width, height: width)
    }
}

extension GalleryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        self.gallerys = []
        // Debounce the network call for searching
        self.debouncer.renewInterval()
        debouncer.handler = {
            self.populateGalleries()
            self.galleryCollectionView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.gallerySearchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.gallerySearchBar.showsCancelButton = false
        self.searchText = ""
        self.gallerySearchBar.text = ""
        self.gallerySearchBar.resignFirstResponder()
        self.gallerys = []
        self.currentPage = 0
        self.galleryCollectionView.reloadData()
    }
}

