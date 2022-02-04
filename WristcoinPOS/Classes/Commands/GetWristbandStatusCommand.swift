//
//  GetWristbandStatusCommand.swift
//  WristcoinPOS
//
//  Created by David Shalaby on 2020-11-30.
//  Copyright (c) 2020 Wristcoin Inc. All rights reserved.
//

import Foundation
import TCMPTappy

@objc public class GetWristbandStatusCommand : NSObject, TCMPMessage{
    @objc public var commandFamily: [UInt8] = CommandFamily.wristcoinPOS
    
    @objc public var commandCode: UInt8 = WristcoinPOSCommandCode.getWristbandStatus.rawValue
    
    @objc public var payload: [UInt8] {
        get{
            if let timeoutValue = timeout{
                return [timeoutValue]
            }else{
                return []
            }
        }
    }
    
    @objc public func parsePayload(payload: [UInt8]) throws {
        if payload.count < 1 {
            return
        }else{
            timeout = payload[0]
        }
    }
    
    @objc public init(payload : [UInt8]) throws {
        super.init()
        try parsePayload(payload: payload)
    }
    
    @objc public init(timeout : UInt8) throws {
        super.init()
        self.timeout = timeout
    }
    
    @objc public override init(){
        super.init()
    }
    
    
    /*If no timeout specified the default timeout on the Bluetooth terminal will apply - usually about 8 seconds or so*/
    public private(set) var timeout : UInt8?
    
}


