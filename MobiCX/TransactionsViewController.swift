//
//  TransactionsViewController.swift
//  MobiCX
//
//  Created by Derin Ozerman on 2017-08-10.
//  Copyright © 2017 Derin Ozerman. All rights reserved.
//

import UIKit
import SwiftyJSON

class TransactionsViewController: UITableViewController, MobiCXViewControllerProtocol {

    var timer: Timer?
    var transactions: Array<JSON> = []
    
    @IBOutlet var transactionsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    override func didReceiveMemoryWarning() {
        // Dispose of any resources that can be recreated.
    }
    
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

    func startTimer() {
        updatePrices()
        self.timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(updatePrices), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        self.timer?.invalidate()
    }
    
    @objc func updatePrices() {
        print("updating latest transactions")
        APICommunicator.sharedInstance.getRecentTransactions(currencyPair: .BTCCAD, onCompletion: { (transactions: Array<JSON>) in
            DispatchQueue.main.async {
                print("received transactions:  ")
                print(transactions)
                
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
