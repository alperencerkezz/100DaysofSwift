//
//  ViewController.swift
//  Project1_Day16
//
//  Created by Alperen Çerkez on 8.09.2024.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    var selectedPictureNumber = 0
    var totalPictures = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
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
            print(self?.pictures ?? [])

            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func recommendApp() {
        let recommendationText = "Check out the Storm Viewer app! It's great for viewing storm images."
        let activityVC = UIActivityViewController(activityItems: [recommendationText], applicationActivities: [])

        activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem

        present(activityVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        let imageName = pictures[indexPath.row]
        
        cell.textLabel?.text = imageName
        
        let image = UIImage(named: imageName)
        
        cell.imageView?.image = image
        cell.imageView?.contentMode = .scaleAspectFit
        
        cell.imageView?.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
