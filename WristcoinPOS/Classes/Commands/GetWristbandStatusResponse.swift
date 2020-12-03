//
//  GetWristbandStatusResponse.swift
//  WristcoinPOS
//
//  Created by David Shalaby on 2020-11-30.
//  Copyright (c) 2020 Wristcoin Inc. All rights reserved.
//

import Foundation
import TCMPTappy

@objc public class GetWristbandStatusResponse : NSObject, TCMPMessage{
    @objc public var commandFamily: [UInt8] = CommandFamily.wristcoinPOS
    
    @objc public var commandCode: UInt8 = WristcoinPOSResponseCode.wristbandStatus.rawValue
    
    @objc public var payload: [UInt8] {
        get{
            return wristbandStatusTlvs
        }
    }
    
    @objc public func parsePayload(payload: [UInt8]) throws {
        if payload.count < 3 {
            throw TCMPParsingError.payloadTooShort
        }else{
            wristbandStatusTlvs = payload
        }
    }
    
    @objc public init(payload : [UInt8]) throws {
        super.init()
        try parsePayload(payload: payload)
    }
    
    /*Todo: For now we will make this just a byte array, future releases will support actual TLV objects*/
    @objc public private(set) var wristbandStatusTlvs : [UInt8] = []
    
}
