//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Angela Yu on 18/08/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import StoreKit
import UIKit

class QuoteTableViewController: UITableViewController {
    let productID = "com.toutava.InspoQuotes.PremiumQuotes"

    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis",
    ]

    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        if isPurchased() {
            showPremiumQuotes()
        }

        SKPaymentQueue.default().add(self)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let canBuy = !isPurchased() && SKPaymentQueue.canMakePayments()

        return quotesToShow.count + (canBuy ? 1 : 0)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)

        if indexPath.row < quotesToShow.count {
            let quote = quotesToShow[indexPath.row]
            cell.textLabel?.text = quote
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = nil
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "Get More Quotes"
            cell.textLabel?.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }

    // MARK: - Table view delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count {
            makePurchase()
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - In-app purchases

    func makePurchase() {
        let paymentRequest = SKMutablePayment()
        paymentRequest.productIdentifier = productID
        SKPaymentQueue.default().add(paymentRequest)
    }

    func restorePurchase() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    func showPremiumQuotes() {
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
        navigationItem.rightBarButtonItem = nil
    }

    func setPurchased() {
        UserDefaults.standard.set(true, forKey: productID)
        showPremiumQuotes()
    }

    func isPurchased() -> Bool {
        return UserDefaults.standard.bool(forKey: productID)
    }

    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        restorePurchase()
    }
}

extension QuoteTableViewController: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                setPurchased()
                tableView.allowsSelection = true
            case .deferred, .purchasing:
                tableView.allowsSelection = false
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                if let error = transaction.error {
                    let description = error.localizedDescription
                    print("Transaction failed: \(description)")
                }
                tableView.allowsSelection = true
            @unknown default:
                fatalError()
            }
        }
    }
}
