//
//  SetEventIdResponse.swift
//  WristcoinPOS
//
//  Created by David Shalaby on 2020-11-30.
//  Copyright (c) 2020 Wristcoin Inc. All rights reserved.
//

import Foundation
import TCMPTappy

@objc public class SetEventIdResponse : NSObject, TCMPMessage{
    public var commandFamily: [UInt8] = CommandFamily.wristcoinPOS
    
    public var commandCode: UInt8 = WristcoinPOSResponseCode.eventIdSet.rawValue
    
    public var payload: [UInt8] {
        get{
            return []
        }
    }
    
    @objc public init(payload : [UInt8]) throws {
        super.init()
        try parsePayload(payload: payload)
    }
    
    public func parsePayload(payload: [UInt8]) throws {}
    
}
