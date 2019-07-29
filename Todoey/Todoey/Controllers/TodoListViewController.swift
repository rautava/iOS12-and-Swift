//
//  ViewController.swift
//  Todoey
//
//  Created by Tommi Rautava on 29/07/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import UIKit
import CoreData

let TodoListArrayKey: String = "TodoListArray"


class TodoListViewController: UITableViewController {
    var itemArray = [Item]() {
        didSet {
            applyFilter()
        }
    }

    var filteredArray = [Item]()

    var selectedCategory: Category? {
        didSet {
            itemArray = (selectedCategory?.items?.allObjects as! [Item]).sorted {
                $0.title!.lowercased() < $1.title!.lowercased()
            }
        }
    }

    var filterText: String = "" {
        didSet {
            applyFilter()
        }
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - TableView Data Source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = filteredArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }

    // MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = filteredArray[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)

        item.toggleDone()
        saveContext()
        cell?.accessoryType = item.done ? .checkmark : .none

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Data Storage Methods

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }

    // MARK: - Add New Item

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let item = Item(context: self.context, title: textField.text!, category: self.selectedCategory)
            self.itemArray.append(item)
            self.saveContext()
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }

    private func applyFilter() {
        if filterText.count == 0 {
            filteredArray = itemArray
            return
        }

        filteredArray = itemArray.filter {
            (item) -> Bool in
            return item.title!.lowercased().contains(filterText)
        }
    }
}


extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterText = searchText.lowercased()
        tableView.reloadData()

        if searchText.count == 0 {
            searchBar.resignFirstResponder()
        }
    }
}
