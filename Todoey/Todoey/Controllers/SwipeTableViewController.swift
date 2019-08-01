//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Tommi Rautava on 01/08/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import SwipeCellKit
import UIKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    var backgroundColor = UIColor.white
    var textColor = UIColor.black

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.rowHeight = 60
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.backgroundColor = backgroundColor
        tableView.tintColor = textColor

        guard let navigationController = navigationController else { fatalError("NavigationController does not exist") }
        navigationController.navigationBar.barTintColor = backgroundColor
        navigationController.navigationBar.tintColor = textColor
        navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: nil) {
            _, _ in

            self.deleteObject(at: indexPath)
        }

        deleteAction.image = UIImage(named: "deleteIcon")

        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }

    public func deleteObject(at indexPath: IndexPath) {
        // Void
    }
}
