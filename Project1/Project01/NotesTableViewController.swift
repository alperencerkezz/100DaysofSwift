//
//  NotesTableViewController.swift
//  Project01
//
//  Created by Alperen Çerkez on 8.12.2024.
//

import UIKit

class NotesTableViewController: UITableViewController {
    var notes = ["Buy groceries", "Finish homework", "Call mom", "Plan weekend trip"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedNote = notes[indexPath.row]
        print("Selected Note: \(selectedNote)")
    }

    @objc func addNote() {
        let alertController = UIAlertController(title: "New Note", message: "Add a new note", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter your note here..."
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let newNote = alertController.textFields?.first?.text, !newNote.isEmpty {
                self?.notes.append(newNote)
                self?.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
