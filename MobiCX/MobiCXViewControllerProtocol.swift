//
//  MobiCXViewController.swift
//  MobiCX
//
//  Created by Derin Ozerman on 2017-08-09.
//  Copyright © 2017 Derin Ozerman. All rights reserved.
//

import Foundation

protocol MobiCXViewControllerProtocol: AnyObject {
    
    var timer: Timer? { get set }
    
    func startTimer()
    func stopTimer()
    func updatePrices()
    
}
