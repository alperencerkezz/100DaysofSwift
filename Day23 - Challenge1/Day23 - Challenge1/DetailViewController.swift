//
//  DetailViewController.swift
//  Day23 - Challenge1
//
//  Created by Alperen Çerkez on 16.09.2024.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    @IBAction func shareTapped() {
        let image = imageView.image!
        let vc = UIActivityViewController(activityItems: [image, selectedImage ?? "Unknown Country"], applicationActivities: [])
        present(vc, animated: true)
    }
}
