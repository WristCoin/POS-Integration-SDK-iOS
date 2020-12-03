//
//  DebitWristbandFullRespCommand.swift
//  WristcoinPOS
//
//  Created by David Shalaby on 2020-11-30.
//  Copyright (c) 2020 Wristcoin Inc. All rights reserved.
//

import Quick
import Nimble
import WristcoinPOS
import TCMPTappy
import XCTest

class WristcoinPOSSpec: QuickSpec {
    override func spec() {
        describe("A composed SetEventIdCommand") {
            context("with a UUID string") {
                it("should match the correct byte array"){
                    let testEventIdArray : [UInt8] = [0xA6, 0x49, 0xE0, 0xF4, 0x0B, 0xC0, 0x11, 0xEA, 0x84, 0xD8, 0xAF, 0xBA, 0xB2, 0xCF, 0xCB, 0x2A]
                    var cmd : SetEventIdCommand
                    try! cmd  = SetEventIdCommand(eventId: UUID(uuidString: "a649e0f4-0bc0-11ea-84d8-afbab2cfcb2a")!)
                    expect(cmd.eventId).to(equal(testEventIdArray))
                }
            }
        }
        
        describe("A composed GetWristbandStatusCommand") {
            context("with a timeout") {
                it("should have a single byte matching payload"){
                    var cmd : GetWristbandStatusCommand
                    try! cmd  = GetWristbandStatusCommand(timeout: 254)
                    expect(cmd.payload).to(equal([0xFE]))
                }
            }
        }
        
        describe("A composed GetWristbandStatusCommand") {
            context("without a timeout") {
                it("should have an empty payload"){
                    let cmd : GetWristbandStatusCommand = GetWristbandStatusCommand()
                    expect(cmd.payload).to(equal([]))
                }
            }
        }
        
        describe("A composed DebitWristbandCommand") {
            context("with a timeout") {
                it("should have a five byte matching payload"){
                    var cmd : DebitWristbandShortRespCommand
                    try! cmd  = DebitWristbandShortRespCommand(debitAmountCentavos: 547690473, timeout: 33)
                    expect(cmd.payload).to(equal([0x20,0xA5,0x17,0xE9,0x21]))
                }
            }
        }
        
        describe("A composed DebitWristbandCommand") {
            context("without a timeout") {
                it("should have a four byte matching payload"){
                    var cmd : DebitWristbandShortRespCommand
                    try! cmd  = DebitWristbandShortRespCommand(debitAmountCentavos: 547690473)
                    expect(cmd.payload).to(equal([0x20,0xA5,0x17,0xE9]))
                }
            }
        }
        
        describe("A composed DebitWristbandCommandFull") {
            context("with a timeout") {
                it("should have a five byte matching payload"){
                    var cmd : DebitWristbandFullRespCommand
                    try! cmd  = DebitWristbandFullRespCommand(debitAmountCentavos: 547690473, timeout: 33)
                    expect(cmd.payload).to(equal([0x20,0xA5,0x17,0xE9,0x21]))
                }
            }
        }
        
        describe("A composed DebitWristbandCommandFull") {
            context("without a timeout") {
                it("should have a four byte matching payload"){
                    var cmd : DebitWristbandFullRespCommand
                    try! cmd  = DebitWristbandFullRespCommand(debitAmountCentavos: 547690473)
                    expect(cmd.payload).to(equal([0x20,0xA5,0x17,0xE9]))
                }
            }
        }
        
        describe("A composed") {
            context("GetWristcoinPOSCommandFamilyVersionCommand") {
                it("should have an empty payload"){
                    let cmd : GetWristcoinPOSCommandFamilyVersionCommand = GetWristcoinPOSCommandFamilyVersionCommand()
                    expect(cmd.payload).to(equal([]))
                }
            }
        }
    }
}
