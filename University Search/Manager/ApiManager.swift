//
//  ApiManager.swift
//  University Search
//
//  Created by Mikhail Yaskou on 07.02.2019.
//  Copyright © 2019 Mikhail Yaskou. All rights reserved.
//

import UIKit

class ApiManager {

let defaultSession = URLSession(configuration: .default)
var dataTask: URLSessionDataTask?

    func getSearchResults(searchTerm: String, completion: @escaping ([University]?)->()) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: "http://universities.hipolabs.com/search") {
            urlComponents.query = "name=\(searchTerm)"
            guard let url = urlComponents.url else { return }
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                if let error = error {
                    print( "DataTask error: " + error.localizedDescription)
                    completion(nil)
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    let univers = try! JSONDecoder().decode([University].self, from: data)
                    completion(univers)
                }
            }
            dataTask?.resume()
        }
    }
    
    func loadImageFromServerURL(_ URLString: String) {
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("Error loading image from URL: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            UniversityManager.shared.imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            NotificationCenter.default.post(Notification.init(name: Notification.Name( URLString), object: nil, userInfo: nil))
                        }
                    }
                }
            }).resume()
        }
    }

}

