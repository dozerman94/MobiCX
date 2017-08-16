//
//  TransactionsViewController.swift
//  MobiCX
//
//  Created by Derin Ozerman on 2017-08-10.
//  Copyright © 2017 Derin Ozerman. All rights reserved.
//

import UIKit
import SwiftyJSON
import DropDown

class TransactionsViewController: UITableViewController, MobiCXViewControllerProtocol {

    var timer: Timer?
    var transactions: Array<JSON> = []
    var currencyPair: CurrencyPair = .BTCCAD
    let dropDown = DropDown()
    
    @IBOutlet var transactionsTableView: UITableView!
    @IBOutlet weak var currencySelectButton: UIBarButtonItem!
    
    // MARK: UIViewController functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        configureDropDown(intialCurrency: "BTC/CAD")
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    override func didReceiveMemoryWarning() {
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath)
        
        let transaction: JSON = self.transactions[indexPath.item]
        
        cell.textLabel?.text = transaction["price"].stringValue
        if transaction["side"].stringValue == "buy" {
            cell.textLabel?.textColor = UIColor.green
        } else if transaction["side"].stringValue == "sell" {
            cell.textLabel?.textColor = UIColor.red
        }
        
        return cell
    }
    
    // MARK: Dropdown currency menu functions
    
    @IBAction func currencySelectorTapped(_ sender: UIBarButtonItem) {
        print("tapped")
        dropDown.show()
    }
    
    func configureDropDown(intialCurrency: String) {
        dropDown.anchorView = self.currencySelectButton      //connect to button
        dropDown.dataSource = ["BTC/CAD", "BTC/USD", "ETH/BTC", "ETH/CAD"]        // drop down list
        
        // Show drop down menu under button. Doesn't work because of a bug in DropDown: https://github.com/AssistoLab/DropDown/issues/65
        //dropDown.bottomOffset = CGPoint(x: 0, y:(self.currencySelectButton.plainView.bounds.height))
        
        dropDown.selectRow(at: dropDown.dataSource.index(of: intialCurrency)) // select default(initial) from list
        self.currencySelectButton.title = dropDown.selectedItem
        
        // define action after select
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.currencySelectButton.title = item
            self.currencyPair = CurrencyPair(rawValue: item.lowercased().replacingOccurrences(of: "/", with: "_"))!
            self.updatePrices()
        }
    }

    // MARK: Timer functions
    
    func startTimer() {
        updatePrices()
        self.timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(updatePrices), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        self.timer?.invalidate()
    }
    
    // MARK: API call
    
    @objc func updatePrices() {
        print("updating latest transactions")
        APICommunicator.sharedInstance.getRecentTransactions(currencyPair: self.currencyPair, onCompletion: { (transactions: Array<JSON>) in
            DispatchQueue.main.async {
                print("received transactions")
                self.transactions = transactions
                self.transactionsTableView.reloadData()
            }
        })

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
