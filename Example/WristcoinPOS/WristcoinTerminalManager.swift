//
//  WristcoinTerminalManager.swift
//  WristcoinPOS
//
//  Created by David Shalaby on 2018-03-19.
//  Copyright (c) 2020 Wristcoin Inc. All rights reserved.
//

import Foundation
import TCMPTappy

class WristcoinTerminalManager {

    // MARK: - Properties

    private static var sharedWristcoinTerminalManager: WristcoinTerminalManager = {
        
        let wristcoinTerminalManager : WristcoinTerminalManager = WristcoinTerminalManager()
        return wristcoinTerminalManager
    }()

    // MARK: -

    public var tappyBle : TappyBle?

    // Initialization

    private init() {
    }

    // MARK: - Accessors

    class func shared() -> WristcoinTerminalManager {
        return sharedWristcoinTerminalManager
    }

}

