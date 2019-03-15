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
    
    func loadGalleryBySearch(_ page: Int, _ searchParameters: String, _ clientID: String, completion: @escaping ([Gallery]) -> Void) {
        guard let url = URL(string: ImgurUrl.init(page, searchParameters).urlString) else {
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
}
