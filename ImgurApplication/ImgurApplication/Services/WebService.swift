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
    
    func loadGalleryBySearch(_ page: Int, _ searchParameters: String, _ clientID: String, completion: @escaping ([Gallery]) -> Void) {
        guard let url = URL(string: ImgurUrl.init(page, searchParameters).urlString) else {
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            var gallerys = [Gallery]()
            var gifLink: String?
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let result = json as? [String: Any], let dataArray = result["data"] as? [[String: Any]] {
                    for data in dataArray {
                        if let images = data["images"] as? [[String: Any]], let imageLink = images[0]["link"] as? String, let title = data["title"] as? String {
                            if let gifv = images[0]["gifv"] as? String {
                                gifLink = gifv.replacingOccurrences(of: "gifv", with: "gif")
                            }
                            gallerys.append(Gallery(imageLink, title, nil, gifLink))
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
