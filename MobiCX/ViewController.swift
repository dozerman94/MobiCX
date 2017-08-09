//
//  ViewController.swift
//  MobiCX
//
//  Created by Derin Ozerman on 2017-08-05.
//  Copyright © 2017 Derin Ozerman. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    var timer: Timer?
    
    @IBOutlet weak var BTCCADPriceLabel: UILabel!
    @IBOutlet weak var ETHCADPriceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updatePrices()
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.timer?.invalidate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        self.timer?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print("reappearing")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(updatePrices), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        self.timer?.invalidate()
    }
    
    @objc private func updatePrices() {
        print("updating")
        APICommunicator.sharedInstance.getCurrentPrice(currencyPair: .BTCCAD, onCompletion: { (price: String) in
            DispatchQueue.main.async {
                self.BTCCADPriceLabel.text = price
            }
        })
        
        APICommunicator.sharedInstance.getCurrentPrice(currencyPair: .ETHCAD, onCompletion: { (price: String) in
            DispatchQueue.main.async {
                self.ETHCADPriceLabel.text = price
            }
        })
    }
}

