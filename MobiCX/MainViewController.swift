//
//  ViewController.swift
//  MobiCX
//
//  Created by Derin Ozerman on 2017-08-05.
//  Copyright © 2017 Derin Ozerman. All rights reserved.
//

import UIKit
import SwiftyJSON

class MainViewController: UIViewController, MobiCXViewControllerProtocol {
    
    var timer: Timer?
    
    @IBOutlet weak var BTCCADPriceLabel: UILabel!
    @IBOutlet weak var ETHCADPriceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
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

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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

