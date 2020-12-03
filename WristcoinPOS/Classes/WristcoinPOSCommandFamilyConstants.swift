//
//  WristcoinPOSCommandFamilyConstants.swift
//  WristcoinPOS
//
//  Created by David Shalaby on 2020-11-29.
//  Copyright (c) 2020 Wristcoin Inc. All rights reserved.
//

import Foundation

// MARK: WristcoinPOS Commands & Responses

@objc public enum WristcoinPOSCommandCode: UInt8 {
    case setEventId = 0x01
    case getWristbandStatus = 0x02
    case debitWristbandShortResp = 0x03
    case debitWristbandFullResp = 0x04
    case getCommandFamilyVersion = 0xFF
}

@objc public enum WristcoinPOSResponseCode: UInt8 {
    case eventIdSet = 0x01
    case wristbandStatus = 0x02
    case debitSuccessShortResp = 0x03
    case debitSuccessFullResp = 0x04
    case error = 0x7F
    case commandFamilyVersion = 0xFF
}

// MARK:  - WristcoinPOS Application Error Codes (response code 0x7F)

@objc public enum WristcoinPOSErrorCode: UInt8 {
    case invalidParameter = 0x01
    case wristbandDetectionError = 0x02
    case tooFewParameters = 0x03
    case tooManyParameters = 0x04
    case unsupportedCommandCode = 0x05
    case eventIdNotSet = 0x06
    case wristcoinWalletNotFoundOnWristband = 0x07
    case unableToReadWristcoinWallet = 0x08
    case invalidWristcoinWalletData = 0x09
    case wristbandForDifferentEvent = 0x0A
    case unsupportedWristcoinWalletVersion = 0x0B
    case unsupportedEventId = 0x0C
    case internalErrorTlvHandling = 0x0D
    case possibleCorruptedWristband = 0x0E
    case wristbandNotActivated = 0x0F
    case debitAmoutExceedsMaximumAllowed = 0x10
    case insufficientBalance = 0x11
    case internalErrorCrypto = 0x12
    case wristbandAuthenticationError = 0x13
    case debitOperationFailed = 0x14
    case internalErrorUrlHandling = 0x15
    case deactivatedWristband = 0x16
    case wristbandDetectionTimedOut = 0x17
    case unknownError = 0xFF
}
