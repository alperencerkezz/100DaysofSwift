//
//  DetailViewController.swift
//  Day59 - Challenge
//
//  Created by Alperen Çerkez on 27.11.2024.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var subregionLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    var country: Country?
        override func viewDidLoad() {
            super.viewDidLoad()
            
            flagImageView.layer.borderColor = UIColor.black.cgColor
            flagImageView.layer.borderWidth = 1
            
            flagImageView.backgroundColor = .lightGray
            
            
            if let country = country {
                capitalLabel.text = "Capital: \(country.capital?.first ?? "Unknown")"
                populationLabel.text = "Population: \(country.population)"
                regionLabel.text = "Region: \(country.region)"
                subregionLabel.text = "Subregion: \(country.subregion)"
                currencyLabel.text = "Currency: \(country.currencies?.first?.value.name ?? "Unknown")"
                
                
                let flagUrl = country.flags.png
                
                loadImage(from: flagUrl) { image in
                    self.flagImageView.image = image
                }
            }
        }
        
        
        func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
            guard let url = URL(string: url) else {
                completion(nil)
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        completion(UIImage(data: data))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }.resume()
        }
    }
