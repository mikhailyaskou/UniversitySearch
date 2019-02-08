//
//  UniversityManager.swift
//  University Search
//
//  Created by Mikhail Yaskou on 07.02.2019.
//  Copyright © 2019 Mikhail Yaskou. All rights reserved.
//

import UIKit

class UniversityManager {
    
    static let shared = UniversityManager()
    
    private init(){}
    
    var universities: [University] = []
    var favoriteList: Set<String> = []
    let imageCache = NSCache<NSString, UIImage>()
}
