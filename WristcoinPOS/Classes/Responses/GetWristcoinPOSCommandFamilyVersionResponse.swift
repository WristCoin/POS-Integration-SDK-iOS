//
//  GetWristcoinPOSCommandFamilyVersionResponse.swift
//  WristcoinPOS
//
//  Created by David Shalaby on 2020-11-30.
//  Copyright (c) 2020 Wristcoin Inc. All rights reserved.
//

import Foundation
import TCMPTappy

@objc public class GetWristcoinPOSCommandFamilyVersionResponse: NSObject, TCMPMessage {
    
    @objc public let commandFamily: [UInt8] = CommandFamily.wristcoinPOS
    
    @objc public let commandCode: UInt8 = WristcoinPOSResponseCode.commandFamilyVersion.rawValue
    
    @objc public private(set) var majorVersion: UInt8 = 0x00
    
    @objc public private(set) var minorVersion: UInt8 = 0x00
    
    @objc public var payload: [UInt8] {
        get {
            return [majorVersion] + [minorVersion]
        }
    }
    
    @objc public init(payload: [UInt8]) throws {
        super.init()
        try parsePayload(payload: payload)
    }
    
    @objc public func parsePayload(payload: [UInt8]) throws {
        guard payload.count == 2 else {
            throw TCMPParsingError.payloadTooShort
        }
        
        majorVersion = payload[0]
        minorVersion = payload[1]
    }
    
}
