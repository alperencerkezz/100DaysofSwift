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
    var viewCounts = [String: Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendApp))
        
        
        if let savedCounts = UserDefaults.standard.dictionary(forKey: "viewCounts") as? [String: Int] {
            viewCounts = savedCounts
        }
        
        
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
        
        
        let viewCount = viewCounts[imageName] ?? 0
        cell.detailTextLabel?.text = "Viewed \(viewCount) times"
        
        
        let image = UIImage(named: imageName)
        cell.imageView?.image = image
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedImage = pictures[indexPath.row]
        
        
        viewCounts[selectedImage, default: 0] += 1
        
        
        UserDefaults.standard.set(viewCounts, forKey: "viewCounts")
        
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = selectedImage
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
