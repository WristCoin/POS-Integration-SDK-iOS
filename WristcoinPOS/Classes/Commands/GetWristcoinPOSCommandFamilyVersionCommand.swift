//
//  GetWristcoinPOSCommandFamilyVersionCommand.swift
//  WristcoinPOS
//
//  Created by David Shalaby on 2020-11-30.
//  Copyright (c) 2020 Wristcoin Inc. All rights reserved.
//
import Foundation
import TCMPTappy

@objc public class GetWristcoinPOSCommandFamilyVersionCommand: NSObject, TCMPMessage {
    
    @objc public let commandFamily: [UInt8] = CommandFamily.wristcoinPOS
    
    @objc public let commandCode: UInt8 = WristcoinPOSCommandCode.getCommandFamilyVersion.rawValue
    
    @objc public var payload: [UInt8] = []
    
    @objc public func parsePayload(payload: [UInt8]) throws {}
    
}

