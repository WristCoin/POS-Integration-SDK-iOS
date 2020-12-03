//
//  SetEventIdCommand.swift
//  WristcoinPOS
//
//  Created by David Shalaby on 2020-11-30.
//  Copyright (c) 2020 Wristcoin Inc. All rights reserved.
//

import Foundation
import TCMPTappy

@objc public class SetEventIdCommand : NSObject, TCMPMessage{
    @objc public var commandFamily: [UInt8] = CommandFamily.wristcoinPOS
    
    @objc public var commandCode: UInt8 = WristcoinPOSCommandCode.setEventId.rawValue
    
    @objc public var payload: [UInt8] {
        get{
            return eventId
        }
    }
    
    @objc public func parsePayload(payload: [UInt8]) throws {
        if payload.count < 16 {
            throw TCMPParsingError.payloadTooShort
        }else{
            eventId = payload
        }
    }
    
    @objc public init(payload : [UInt8]) throws {
        super.init()
        try parsePayload(payload: payload)
    }
    
    @objc public init(eventId : [UInt8]) throws {
        super.init()
        try parsePayload(payload: eventId)
    }
    
    public init(eventId : UUID) throws {
        super.init()
        try parsePayload(payload: eventId.asUInt8Array())
    }
    
    @objc public private(set) var eventId : [UInt8] = []
    
}

