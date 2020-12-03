//
//  WristcoinPOSApplicationErrorMessage.swift
//  WristcoinPOS
//
//  Created by David Shalaby on 2020-11-30.
//  Copyright (c) 2020 Wristcoin Inc. All rights reserved.
//

import Foundation
import TCMPTappy

@objc
public class WristcoinPOSApplicationErrorMessage : NSObject, TCMPMessage, TCMPApplicationErrorMessage {
    
    @objc public let commandFamily: [UInt8] = CommandFamily.wristcoinPOS
    
    @objc public let commandCode: UInt8 = WristcoinPOSResponseCode.error.rawValue
    
    @objc public var payload: [UInt8] {
        get {
            return [appErrorCode,internalErrorCode,readerStatusCode] + errorDescription.utf8
        }
    }

    @objc public private(set) var appErrorCode: UInt8 = 0x00
    @objc public private(set) var internalErrorCode: UInt8 = 0x00
    @objc public private(set) var readerStatusCode: UInt8 = 0x00
    @objc public private(set) var errorDescription: String = ""
    
    @objc public init(payload: [UInt8]) throws {
        super.init()
        try parsePayload(payload: payload)
    }
    
    @objc public func parsePayload(payload: [UInt8]) throws {
        guard payload.count > 3 else {
            throw TCMPParsingError.payloadTooShort
        }
        
        appErrorCode = payload[0]
        internalErrorCode = payload[1]
        readerStatusCode = payload[2]
        let errorDescriptionBytes = Data(payload[3...])
        errorDescription = String(data: errorDescriptionBytes, encoding: .utf8)!
    }
}
