//
//  TableViewController.swift
//  Todoey
//
//  Created by Tommi Rautava on 31/07/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadContext()
        fixOrphanItems()
    }

    // MARK: - TableView Data Source Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categoryArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = category.name

        return cell
    }

    // MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let category = categoryArray[indexPath.row]
        //let cell = tableView.cellForRow(at: indexPath)

        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TodoListViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categoryArray[indexPath.row]
            }
        }
    }

    // MARK: - Data Storage Methods

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }

    private func loadContext(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            self.categoryArray = try context.fetch(request)
        } catch {
            print("Error loading context \(error)")
        }

        if categoryArray.count == 0 {
            let category = Category(context: context)
            category.name = "Misc"
        }

        tableView.reloadData()
    }

    // MARK: - Add New Category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)

        var textField = UITextField()

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }

        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let category = Category(context: self.context)
            category.name = textField.text!
            self.categoryArray.append(category)
            self.saveContext()
            self.tableView.reloadData()
        }

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Misc
    private func fixOrphanItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "parentCategory == nil")

        do {
            let itemArray = try context.fetch(request)

            for item in itemArray {
                item.parentCategory = categoryArray[0]
            }

            try context.save()
        } catch {
            print("Error while fixing orphaned items \(error)")
        }
    }
}
