//
//  ViewController.swift
//  Todoey
//
//  Created by Tommi Rautava on 29/07/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import RealmSwift
import UIKit

let TodoListArrayKey: String = "TodoListArray"

class TodoListViewController: SwipeTableViewController {
    var items: Results<Item>?

    var selectedCategory: Category? {
        didSet {
            items = selectedCategory!.items.sorted(byKeyPath: "title", ascending: true)
            backgroundColor = UIColor(hexString: selectedCategory?.color)
            textColor = UIColor(contrastingBlackOrWhiteColorOn: backgroundColor, isFlat: false)
        }
    }

    var filterText: String = "" {
        didSet {
            if filterText.count == 0 {
                filter = NSPredicate(value: true)
                return
            }

            filter = NSPredicate(format: "title CONTAINS[cd] %@", filterText)
        }
    }

    var filter = NSPredicate(value: true)

    @IBOutlet var searchBar: UISearchBar!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        title = selectedCategory?.name

        searchBar.barTintColor = backgroundColor
        searchBar.tintColor = textColor
    }

    // MARK: - TableView Data Source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.filter(filter).count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let item = itemAt(indexPath)

        cell.textLabel?.text = item?.title ?? ""
        cell.accessoryType = (item?.done ?? false) ? .checkmark : .none

        var percentage: CGFloat = 0.0
        let itemCount = items!.count

        if itemCount > 1 {
            percentage = CGFloat(indexPath.row) / CGFloat(itemCount - 1) * 0.3
        }

        let cellColor = backgroundColor.darken(byPercentage: percentage)
        let textColor = UIColor(contrastingBlackOrWhiteColorOn: cellColor, isFlat: false)

        cell.backgroundColor = cellColor
        cell.textLabel?.textColor = textColor
        cell.tintColor = textColor

        return cell
    }

    private func itemAt(_ indexPath: IndexPath) -> Item? {
        return items?.filter(filter)[indexPath.row]
    }

    // MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let item = itemAt(indexPath)

        if let item = item {
            toggleItemDone(item)
        }

        tableView.reloadData()
    }

    // MARK: - Data Manipulation Methods

    private func addItem(title: String) {
        do {
            let realm = try Realm()

            try realm.write {
                let item = Item()
                item.title = title
                self.selectedCategory!.items.append(item)
            }
        } catch {
            print("Error while adding a new item \(error)")
        }
    }

    private func toggleItemDone(_ item: Item) {
        do {
            let realm = try Realm()

            try realm.write {
                item.toggleDone()
            }
        } catch {
            print("Error while toggling done status of an item \(error)")
        }
    }

    private func deleteItem(_ item: Item) {
        do {
            let realm = try Realm()

            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("Error while deleting an item \(error)")
        }
    }

    // MARK: - Add New Item

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) {
            _ in

            self.addItem(title: textField.text!)
            self.tableView.reloadData()
        }

        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    // MARK: - Swipe callback methods

    override func deleteObject(at indexPath: IndexPath) {
        if let item = itemAt(indexPath) {
            deleteItem(item)
        }
    }
}

// MARK: - Search Bar delegate methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterText = searchText.lowercased()
        tableView.reloadData()

        if searchText.count == 0 {
            searchBar.resignFirstResponder()
        }
    }
}
