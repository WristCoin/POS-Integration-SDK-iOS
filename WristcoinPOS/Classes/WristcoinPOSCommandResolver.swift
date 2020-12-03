//
//  WristcoinPOSCommandResolver.swift
//  WristcoinPOS
//
//  Created by David Shalaby on 2020-11-30.
//  Copyright (c) 2020 Wristcoin Inc. All rights reserved.
//

import Foundation
import TCMPTappy

@objc public final class WristcoinPOSCommandResolver: NSObject, MessageResolver{
    
    @objc private static func assertFamilyMatches(message: TCMPMessage) throws {
        if message.commandFamily != CommandFamily.wristcoinPOS {
            throw TCMPParsingError.resolverError(errorDescription: "Specified message is for a different command family. Expected Wristcoin POS command family, got \(bytesToHexString(message.commandFamily)).")        }
    }
    
    @objc public static func resolveCommand(message: TCMPMessage) throws -> TCMPMessage{
        try assertFamilyMatches(message: message)
        var command: TCMPMessage
        
        switch message.commandCode{
        case WristcoinPOSCommandCode.setEventId.rawValue:
            command = try SetEventIdCommand(payload: message.payload)
        case WristcoinPOSCommandCode.getWristbandStatus.rawValue:
            command = try GetWristbandStatusCommand(payload: message.payload)
        case WristcoinPOSCommandCode.debitWristbandShortResp.rawValue:
            command = try DebitWristbandShortRespCommand(payload: message.payload)
        case WristcoinPOSCommandCode.debitWristbandFullResp.rawValue:
            command = try DebitWristbandFullRespCommand(payload: message.payload)
        case WristcoinPOSCommandCode.getCommandFamilyVersion.rawValue:
            command = GetWristcoinPOSCommandFamilyVersionCommand()
        default:
            throw TCMPParsingError.resolverError(errorDescription: "Command not recognized by Wristcoin POS command resolver. Command code: \(String(format: "%02X", message.commandCode))")
        }
        
        return command
    }
    
    @objc public static func resolveResponse(message: TCMPMessage) throws -> TCMPMessage{
        try assertFamilyMatches(message: message)
        var response: TCMPMessage
        
        switch message.commandCode{
        case WristcoinPOSResponseCode.error.rawValue:
            response = try WristcoinPOSApplicationErrorMessage(payload: message.payload)
        case WristcoinPOSResponseCode.eventIdSet.rawValue:
            response = try SetEventIdResponse(payload: message.payload)
        case WristcoinPOSResponseCode.wristbandStatus.rawValue:
            response = try GetWristbandStatusResponse(payload: message.payload)
        case WristcoinPOSResponseCode.debitSuccessShortResp.rawValue:
            response = try DebitWristbandShortRespResponse(payload: message.payload)
        case WristcoinPOSResponseCode.debitSuccessFullResp.rawValue:
            response = try DebitWristbandFullRespResponse(payload: message.payload)
        case WristcoinPOSResponseCode.commandFamilyVersion.rawValue:
            response = try GetWristcoinPOSCommandFamilyVersionResponse(payload: message.payload)
        default:
            throw TCMPParsingError.resolverError(errorDescription: "Response not recognized by Wristcoin POS command resolver. Response code: \(String(format: "%02X", message.commandCode))")
        }
        
        return response
    }
    
}
