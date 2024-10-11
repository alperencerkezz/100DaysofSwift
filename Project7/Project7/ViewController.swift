//
//  ViewController.swift
//  Project7
//
//  Created by Alperen Çerkez on 30.09.2024.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(promptForFilter))
        
        // Perform JSON fetching in the background using performSelector
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON() {
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString  = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        // Call showError on the main thread if data fetching fails
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func promptForFilter() {
        let ac = UIAlertController(title: "Filter", message: "Enter a keyword to filter petitions:", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let filter = ac?.textFields?[0].text else { return }
            self?.filterPetitions(filter)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func filterPetitions(_ filter: String) {
        filteredPetitions = petitions.filter { petition in
            return petition.title.localizedCaseInsensitiveContains(filter) || petition.body.localizedCaseInsensitiveContains(filter)
        }
        tableView.reloadData()
    }
    
    @objc func showCredits() {
        let alert = UIAlertController(title: "Credits", message: "Data is sourced from hackingwithswift.com", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            // Handle error by calling showError if JSON parsing fails
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
