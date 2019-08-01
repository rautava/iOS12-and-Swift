//
//  TableViewController.swift
//  Todoey
//
//  Created by Tommi Rautava on 31/07/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import RealmSwift
import UIKit

class CategoryViewController: SwipeTableViewController {
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategories()
    }

    // MARK: - TableView Data Source Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categories?[indexPath.row]

        cell.textLabel?.text = category?.name ?? ""

        return cell
    }

    // MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let category = categoryArray[indexPath.row]
        // let cell = tableView.cellForRow(at: indexPath)

        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TodoListViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }

    // MARK: - Data Storage Methods

    private func addCategory(name: String) {
        do {
            let realm = try Realm()

            try realm.write {
                let category = Category()
                category.name = name
                realm.add(category)
            }
        } catch {
            print("Error while adding a new category \(error)")
        }
    }

    private func deleteCategory(_ category: Category) {
        do {
            let realm = try Realm()

            try realm.write {
                realm.delete(category.items)
                realm.delete(category)
            }
        } catch {
            print("Error while deleting a new category \(error)")
        }
    }

    private func fetchCategories() {
        let realm = try! Realm()

        categories = realm.objects(Category.self)

        tableView.reloadData()
    }

    // MARK: - Add New Category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)

        var textField = UITextField()

        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }

        let action = UIAlertAction(title: "Add Category", style: .default) { _ in
            self.addCategory(name: textField.text!)
            self.tableView.reloadData()
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    // MARK: - Swipe callback methods

    override func deleteObject(at indexPath: IndexPath) {
        if let category = categories?[indexPath.row] {
            deleteCategory(category)
        }
    }
}
