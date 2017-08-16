//
//  APICommunicator.swift
//  MobiCX
//
//  Created by Derin Ozerman on 2017-08-05.
//  Copyright © 2017 Derin Ozerman. All rights reserved.
//

import UIKit
import SwiftyJSON

enum CurrencyPair: String {
    case BTCCAD = "btc_cad"
    case BTCUSD = "btc_usd"
    case ETHBTC = "eth_btc"
    case ETHCAD = "eth_cad"
}

class APICommunicator: NSObject {
    static let sharedInstance = APICommunicator()
    
    let baseURL = "https://api.quadrigacx.com/v2/"
    
    func getCurrentBTCPrice(onCompletion: @escaping (String) -> Void) {
        let path = baseURL + "ticker?book=btc_cad"
        makeHTTPGetRequest(path: path, onCompletion: { json in
            onCompletion(json["last"].stringValue)
        })
    }
    
    func getCurrentPrice(currencyPair: CurrencyPair, onCompletion: @escaping (String) -> Void) {
        let path = baseURL + "ticker?book=" + currencyPair.rawValue
        makeHTTPGetRequest(path: path, onCompletion: { json in
            onCompletion(json["last"].stringValue)
        })
    }
    
    func getRecentTransactions(currencyPair: CurrencyPair, onCompletion: @escaping (Array<JSON>) -> Void) {
        let path = baseURL + "transactions?book=" + currencyPair.rawValue
        makeHTTPGetRequest(path: path, onCompletion: { json in
            onCompletion(json.arrayValue)
        })
    }
    
    // MARK: Perform a GET Request
    private func makeHTTPGetRequest(path: String, onCompletion: @escaping (JSON) -> Void) {
        let request = URLRequest(url: URL(string: path)!)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
//                print(String.init(data: data!, encoding: String.Encoding.utf8)!)
                let json:JSON = JSON(data: jsonData)
                onCompletion(json)
            } else {
                onCompletion(JSON.null)
            }
            
        })
        task.resume()
    }
}
