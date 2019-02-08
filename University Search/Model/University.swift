//
//  University.swift
//  University Search
//
//  Created by Mikhail Yaskou on 07.02.2019.
//  Copyright © 2019 Mikhail Yaskou. All rights reserved.
//

import UIKit

struct University: Decodable {
    let name: String
    let webPages: [String]
    let alphaTwoCode: String
    let stateProvince: String? = nil
    let country: String? = nil
    let domains: [String]
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case webPages = "web_pages"
        case alphaTwoCode = "alpha_two_code"
        case stateProvince = "state-province"
        case country = "country"
        case domains = "domains"
    }
}

extension University {
    
    var imageUrl: String? {
        get {
            guard let domain = domains.first  else { return nil }
            return "https://logo.clearbit.com/" + domain
        }
    }
    
    var isFavorite: Bool {
        get {
            return UniversityManager.shared.favoriteList.contains(name)
        }
        set {
            if newValue {
                UniversityManager.shared.favoriteList.insert(name)
            } else {
                UniversityManager.shared.favoriteList.remove(name)
            }
        }
    }
}
