//
//  DetailViewController.swift
//  NotesAppChallenge
//
//  Created by Alperen Çerkez on 10.12.2024.
//

import UIKit

class DetailViewController: UIViewController {
    var notes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
    }
    
    @objc func addNote() {
        
    }
}
