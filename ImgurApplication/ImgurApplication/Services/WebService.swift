//
//  WebService.swift
//  ImgurApplication
//
//  Created by Katherine Li on 3/6/19.
//  Copyright © 2019 Katherine Li. All rights reserved.
//

import Foundation
import UIKit

struct ImgurUrl {
    let baseUrlString: String
    var pageNumber: Int
    let searchParameter: String
    var searchQuery: String
    var urlString: String
    
    init(_ pageNumber: Int, _ searchParameter: String) {
        self.baseUrlString = "https://api.imgur.com/3/gallery/search/time/"
        self.pageNumber = pageNumber
        self.searchParameter = searchParameter
        self.searchQuery = "?q=\(searchParameter)"
        self.urlString = self.baseUrlString + String(self.pageNumber) + self.searchQuery
    }
}

class WebService {
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    func loadGalleryBySearch(_ searchParameters: String, _ clientID: String, completion: @escaping ([Gallery]) -> Void) {
        guard let url = URL(string: ImgurUrl.init(1, searchParameters).urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            var gallerys = [Gallery]()
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let result = json as? [String: Any], let dataArray = result["data"] as? [[String: Any]] {
                    for data in dataArray {
                        print(data)
                        if let images = data["images"] as? [[String: Any]], let imageLink = images[0]["link"] as? String, let title = data["title"] as? String {
                            gallerys.append(Gallery(imageLink, title))
                        }
                    }
                }
            } catch (let error) {
                print("WebService request failed with: \(error)")
            }
            
            DispatchQueue.main.async {
                completion(gallerys)
            }
            
        }.resume()
    }
    
    func loadImageFromUrl(_ urlString: String, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage, nil)
        } else {
            guard let url = URL(string: urlString) else {
                return
            }
            
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(nil, error)
                } else if let data = data, let image = UIImage(data: data) {
                    self.imageCache.setObject(image, forKey: urlString as NSString)
                    completion(image, nil)
                }
            }.resume()
        }
        
    }
    
}
