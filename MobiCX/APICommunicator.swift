//
//  APICommunicator.swift
//  MobiCX
//
//  Created by Derin Ozerman on 2017-08-05.
//  Copyright © 2017 Derin Ozerman. All rights reserved.
//

import UIKit
import SwiftyJSON

enum currencyPair: String {
    case BTCCAD = "btc_cad"
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
    
    func getCurrentPrice(currencyPair: currencyPair, onCompletion: @escaping (String) -> Void) {
        let path = baseURL + "ticker?book=" + currencyPair.rawValue
        makeHTTPGetRequest(path: path, onCompletion: { json in
            onCompletion(json["last"].stringValue)
        })
    }
    
    // MARK: Perform a GET Request
    private func makeHTTPGetRequest(path: String, onCompletion: @escaping (JSON) -> Void) {
        let request = URLRequest(url: URL(string: path)!)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                onCompletion(json)
            } else {
                onCompletion(JSON.null)
            }
            
        })
        task.resume()
    }
}
