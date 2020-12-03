//
//  DebitWristbandShortRespResponse.swift
//  WristcoinPOS
//
//  Created by David Shalaby on 2020-11-30.
//  Copyright (c) 2020 Wristcoin Inc. All rights reserved.
//

import Foundation
import TCMPTappy

@objc public class DebitWristbandShortRespResponse : NSObject, TCMPMessage{
    @objc public var commandFamily: [UInt8] = CommandFamily.wristcoinPOS
    
    @objc public var commandCode: UInt8 = WristcoinPOSResponseCode.debitSuccessShortResp.rawValue
    
    @objc public var payload: [UInt8] {
        get{
            if let resultingBalance = remainingBalanceCentavos{
                return withUnsafeBytes(of: resultingBalance.bigEndian, Array.init)
            }else{
                return []
            }
        }
    }
    
    @objc public func parsePayload(payload: [UInt8]) throws {
        if payload.count < 4 {
            throw TCMPParsingError.payloadTooShort
        }else{
            let data = Data(bytes: payload)
            remainingBalanceCentavos = Int32(bigEndian: data.withUnsafeBytes { $0.pointee })
        }
    }
    
    @objc public init(remainingBalance: Int32){
        self.remainingBalanceCentavos = remainingBalance
    }
    
    @objc public init(payload : [UInt8]) throws {
        super.init()
        try parsePayload(payload: payload)
    }
    
    public private(set) var remainingBalanceCentavos : Int32?
    
}




