//
//  ViewController.swift
//  Day59 - Challenge
//
//  Created by Alperen Çerkez on 27.11.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var countries: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        loadCountries()
    }
    
    func loadCountries() {
        if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                self.countries = try decoder.decode([Country].self, from: data)
                tableView.reloadData()
            } catch {
                print("Error loading or decoding JSON: \(error)")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.name.common
        return cell
    }
    
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = countries[indexPath.row]
        performSegue(withIdentifier: "showDetails", sender: country)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails",
           let detailVC = segue.destination as? DetailViewController,
           let country = sender as? Country {
            detailVC.country = country
        }
    }
}
