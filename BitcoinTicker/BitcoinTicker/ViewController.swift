//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]
    var currency = ""
    var finalURL = ""

    // Pre-setup IBOutlets
    @IBOutlet var bitcoinPriceLabel: UILabel!
    @IBOutlet var bitcoinSymbolLabel: UILabel!
    @IBOutlet var currencyPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currency = currencyArray[row]
        finalURL = baseURL + currency
        getBitcoinValue(url: finalURL)
    }

    // MARK: - Networking

    /***************************************************************/

    func getBitcoinValue(url: String) {
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    let json: JSON = JSON(response.result.value!)
                    self.updateUI(json: json)
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }
    }

    // MARK: - JSON Parsing

    /***************************************************************/

    func updateUI(json: JSON) {
        let value = json["last"].doubleValue as NSNumber
        let symbol = json["display_symbol"].stringValue

        print(Locale.current.identifier)

        let formatter = NumberFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.numberStyle = .currencyAccounting
        formatter.currencyCode = currency

        bitcoinPriceLabel.text = formatter.string(from: value)
        bitcoinSymbolLabel.text = symbol
    }
}
