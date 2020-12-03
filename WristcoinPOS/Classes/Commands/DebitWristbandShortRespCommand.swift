//
//  DebitWristbandShortRespCommand.swift
//  WristcoinPOS
//
//  Created by David Shalaby on 2020-11-30.
//  Copyright (c) 2020 Wristcoin Inc. All rights reserved.
//

import Foundation
import TCMPTappy

@objc public class DebitWristbandShortRespCommand : NSObject, TCMPMessage{
    @objc public var commandFamily: [UInt8] = CommandFamily.wristcoinPOS
    
    @objc public var commandCode: UInt8 = WristcoinPOSCommandCode.debitWristbandShortResp.rawValue
    
    @objc public var payload: [UInt8] {
        get{
            if let timeoutValue = timeout {
                return withUnsafeBytes(of: debitAmountCentavos.bigEndian, Array.init) + [timeoutValue]
            }else{
                return withUnsafeBytes(of: debitAmountCentavos.bigEndian, Array.init)
            }
        }
    }
    
    @objc public func parsePayload(payload: [UInt8]) throws {
        if payload.count < 4 {
            throw TCMPParsingError.payloadTooShort
        }else if payload.count == 4 {
            let data = Data(bytes: payload)
            debitAmountCentavos = UInt32(bigEndian: data.withUnsafeBytes { $0.pointee })
        }else if payload.count > 4 {
            let data = Data(bytes: payload)
            debitAmountCentavos = UInt32(bigEndian: data.withUnsafeBytes { $0.pointee })
            timeout = UInt8(payload[4])
        }
    }
    
    @objc public init(payload : [UInt8]) throws {
        super.init()
        try parsePayload(payload: payload)
    }
    
    @objc public init(debitAmountCentavos : UInt32) throws {
        super.init()
        self.debitAmountCentavos = debitAmountCentavos
    }
    
    @objc public init(debitAmountCentavos : UInt32, timeout : UInt8) throws {
        super.init()
        self.debitAmountCentavos = debitAmountCentavos
        self.timeout = timeout
    }
    
    @objc public private(set) var debitAmountCentavos : UInt32 = 0
    public private(set) var timeout : UInt8?
}


