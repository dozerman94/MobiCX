//
//  TransactionsViewController.swift
//  MobiCX
//
//  Created by Derin Ozerman on 2017-08-10.
//  Copyright © 2017 Derin Ozerman. All rights reserved.
//

import UIKit

class TransactionsViewController: UITableViewController, MobiCXViewControllerProtocol {

    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startTimer() {
        updatePrices()
        self.timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(updatePrices), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        self.timer?.invalidate()
    }
    
    @objc func updatePrices() {
        print("updating")
        APICommunicator.sharedInstance.getCurrentPrice(currencyPair: .BTCCAD, onCompletion: { (price: String) in
            DispatchQueue.main.async {
//                self.BTCCADPriceLabel.text = price
            }
        })
        
        APICommunicator.sharedInstance.getCurrentPrice(currencyPair: .ETHCAD, onCompletion: { (price: String) in
            DispatchQueue.main.async {
//                self.ETHCADPriceLabel.text = price
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
