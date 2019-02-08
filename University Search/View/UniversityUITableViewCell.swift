//
//  UniversityUITableViewCell.swift
//  University Search
//
//  Created by Mikhail Yaskou on 07.02.2019.
//  Copyright © 2019 Mikhail Yaskou. All rights reserved.
//

import UIKit

class UniversityUITableViewCell: UITableViewCell {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    
    var university: University!
    let apiManager =  ApiManager()
    
    func configureCell(with university: University) {
        
        self.university = university
        
        titleLabel.text = university.name
        descriptionLabel.text = university.country
        starLabel.isHidden = !university.isFavorite
        
        guard let imageUrl = university.imageUrl else {
            return
        }
        
        if let cachedImage = UniversityManager.shared.imageCache.object(forKey: imageUrl as NSString) {
            logoImageView.image = cachedImage
        } else {
             logoImageView.image = UIImage(named: "defaultLogo")
            NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: Notification.Name(imageUrl), object: nil)
            apiManager.loadImageFromServerURL(imageUrl)
        }
    }
    
    @objc func onDidReceiveData(_ notification: Notification) {
        if let cachedImage = UniversityManager.shared.imageCache.object(forKey: NSString(string: notification.name.rawValue)) {
            logoImageView.image = cachedImage
        } 
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        guard let imageUrl = university.imageUrl else {
            university = nil
            return
        }
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(imageUrl), object: nil)
        university = nil
    }
}
