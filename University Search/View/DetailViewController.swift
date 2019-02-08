//
//  DetailViewController.swift
//  University Search
//
//  Created by Mikhail Yaskou on 08.02.2019.
//  Copyright © 2019 Mikhail Yaskou. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    static func instance(with university: University) -> DetailViewController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            controller.university = university
            return controller
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var locaionLabel: UILabel!
    @IBOutlet weak var favoriteSwich: UISwitch!
    
    var university: University!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        guard let imageUrl = university.imageUrl else {
            return
        }
        
        if let cachedImage = UniversityManager.shared.imageCache.object(forKey: imageUrl as NSString) {
            imageView.image = cachedImage
        } else {
            imageView.image = UIImage(named: "defaultLogo")
        }
        
        titleLabel.text = university.name
        domainLabel.text = university.domains.first ?? ""
        locaionLabel.text = university.country
        favoriteSwich.setOn(university.isFavorite, animated: false)
    }
    
    @IBAction func favoriteSwichChanged(_ sender: UISwitch) {
        university.isFavorite = sender.isOn
    }
    
    @IBAction func linkButtonTapped(_ sender: Any) {
        if let url = URL(string: university.imageUrl ?? "") {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
