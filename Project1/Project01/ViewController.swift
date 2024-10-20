//
//  ViewController.swift
//  Project1_Day16
//
//  Created by Alperen Çerkez on 8.09.2024.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    var pictures = [String]()
    var selectedPictureNumber = 0
    var totalPictures = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Register the cell class or nib if needed
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PictureCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendApp))

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)

            for item in items {
                if item.hasPrefix("nssl") {
                    self?.pictures.append(item)
                }
            }
            
            self?.pictures.sort()

            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    @objc func recommendApp() {
        let recommendationText = "Check out the Storm Viewer app! It's great for viewing storm images."
        let activityVC = UIActivityViewController(activityItems: [recommendationText], applicationActivities: [])
        activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem

        present(activityVC, animated: true)
    }

    // MARK: - UICollectionView DataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath)
        
        let imageName = pictures[indexPath.item]
        let imageView = UIImageView(image: UIImage(named: imageName))
        
        imageView.contentMode = .scaleAspectFit
        imageView.frame = cell.contentView.frame
        
        cell.contentView.addSubview(imageView)
        
        return cell
    }

    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.item]
            vc.selectedPictureNumber = indexPath.item + 1
            vc.totalPictures = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

