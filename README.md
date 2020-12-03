# WristcoinPOS Integration SDK for iOS

[![License](https://img.shields.io/cocoapods/l/TCMPTappy.svg?style=flat)](https://github.com/WristCoin/POS-Integration-SDK-iOS/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/TCMPTappy.svg?style=flat)](https://cocoapods.org/pods/TCMPTappy)
![Xcode](https://img.shields.io/badge/Xcode-12.2-brightgreen.svg)
![Swift](https://img.shields.io/badge/Swift-4.2-brightgreen.svg)

## Introduction

This project is an SDK to allow POS vendors to integrate WristCoin contactless cashless payments and accept WristCoin wallets as a form of payment. 

A prerequisite to using this SDK is having the WristCoin external Bluetooth terminal that accepts NFC payments using WristCoin wristbands/cards/fobs.   The terminal abastracts all of the NFC details away from your POS application.  Detailed specifications about the Bluetooth connection handling, communication protocol, and requirements are outside the scope of this SDK.  The required dependency to connect and communicate with the terminal is already included in WristcoinPOS Cocoapod.  If interested, please refer [here](https://github.com/TapTrack/TCMPTappy-iOS) for details regarding the Bluetooth communications such as scanning for terminals, connecting, sending and receiving data. 

We are currently in a closed beta program for our POS integration program.  To enroll in the closed beta please email info@mywristcoin.com to obtain your development terminal. 

## Features

The SDK currently supports the following operations:

* Event selection
* Reading wristband status and balance information
* Debiting the wristband a specified amount
* Getting the terminal's firmware version

### Sending commands to the WristCoin Bluetooth NFC terminal

After each command has been created, to send it to the terminal (assming the the terminal is connected):

`yourWristcoinTerminal.sendMessage(message: setEventIdCmd)`

where `yourWristcoinTerminal` is of type `TappyBle`  (provided by the `TCMPTappy` module)

### Receiving responses from the WristCoin Bluetooth NFC terminal

Once connected to a WristCoin Bluetooth NFC terminal, you must set a response listener to handle data being received from the terminal:

`yourWristcoinTerminal.setResponseListener(listener: myWCTerminalResponseListener)`

where `yourWristcoinTerminal` is of type `TappyBle`  (provided by the `TCMPTappy` module).

The function `yourWristcoinTerminal` must adopt the following method signature:

`func myWCTerminalResponseListener(tcmpResponse : TCMPMessage)`

### Event Selection

At the moment Wristcoin terminals are pre-configured at the factory for your event(s) you specify when ordering the terminals. Setting the event id selects the event your POS is using.  Passing an event id that the terminal was not configured for at the factory will result in an error returned from the Wristcoin terminal.  Future versions of the POS integration program will allow on-the-fly configuration of terminals for various events but at the moment the factory configuration will have to match the event id you're working with. 

Declare a set event id command:

`let setEventIdCmd: SetEventIdCommand`

To set the event id:

`try! cmd  = SetEventIdCommand(eventId: UUID(uuidString: "a649e0f4-0bc0-11ea-84d8-afbab2cfcb2a")!)`

or if you already have the 16 byte `UInt8` array:

`try! setEventIdCmd = SetEventIdCommand(eventId: [0xA6,0x49,0xE0,0xF4,0x0B,0xC0,0x11,0xEA,0x84,0xD8,0xAF,0xBA,0xB2,0xCF,0xCB,0x2A])`

Then send the command to the terminal as shown above.   It's recommended you handle exceptions that may be thrown, the  examples provided are intended for explanatory purposes only and hence are kept to a single line of code, but in practice handling 

### Debiting Wristband Credit - Short Response

The short response version of this command is intended to allow a quick and easy integration if there is no need to have the terminal report back the full wristband status.  This command simply returns the available balance on the wristband after the requested amount is debited.  This avoids having to handle and parse TLV data if all that is needed  for the integration is to know the resulting balance from the transaction. 

Declare a debit wristband short response command:

`let  debitWristbandShortRespCmd : DebitWristbandShortRespCommand`

To request to debit one dollar (or pesos, euros, pounds, etc..):

`try! debitWristbandShortRespCmd = DebitWristbandShortRespCommand(debitAmountCentavos: 100)`

This will use the terminal's default timeout of about eight seconds or so.  To specify your own timeout, say 12 seconds:

`try! debitWristbandShortRespCmd = DebitWristbandShortRespCommand(debitAmountCentavos: 100, timeout: 12)`
 
 Note: Specifying a timeout is interpreted as seconds from 0-255 seconds, 0 indicating no timeout (poll for a wristband until interrupted). Then send the command to the terminal as shown above. 

### Debiting Wristband Credit - Full Response

For integrations that require the full resulting wristband status after a debit transaction, the full response version of the debit command is used.  This returns the complete resulting wristband status as a TLV array which would then require validation and parsing (note: future releases of the SDK will have a TLV library provided for this purpose).  

Declare a debit wristband full response command:

`let  debitWristbandFullRespCmd : DebitWristbandFullRespCommand`

To request to debit one dollar (or pesos, euros, pounds, etc..):

`try! debitWristbandFullRespCmd = DebitWristbandFullRespCommand(debitAmountCentavos: 100)`

This will use the terminal's default timeout of about eight seconds or so.  To specify your own timeout, say 12 seconds:

`try! debitWristbandFullRespCmd = DebitWristbandFullRespCommand(debitAmountCentavos: 100, timeout: 12`
 
 Note: Specifying a timeout is interpreted as seconds from 0-255 seconds, 0 indicating no timeout (poll for a wristband until interrupted). Then send the command to the terminal as shown above. 

### Getting Terminal Firmware Version

This command is handy to know what version of terminal firmware you have - especially useful as the beta program continues as new features are added:

`let getTerminalFirmwareVerCmd : GetFirmwareVersionCommand = GetFirmwareVersionCommand()`

Then send the command to the terminal as shown above. 

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.  It contains an example of how to scan for, connect to, and communicate with the WristCoin Bluetooth terminal.

## Tag - Length - Value (TLV) Data Encoding Specification

Coming soon: When returning wristband account/status information, the terminals use a TLV specification to encode the data.  Star this repo to watch for updates as more documentation is released in the coming weeks.

## Requirements

* Minimum iOS version for deployment is 12.0
* Swift 4.2
* XCode v12.2 or later recommended

`WristcoinPOS` pod depends on the `TCMPTappy pod` for Bluetooth reader communications. 

## Installation

WristcoinPOS is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WristcoinPOS'
```

## Author

dshalaby, dave@mywristcoin.com

## License

WristcoinPOS is available under the Apache 2.0 license. See the LICENSE file for more info.

=======
# POS-Integration-SDK-iOS (Comming Soon...)
SDK for integrating WristCoin payments into Point of Sale systems running on iOS

Stay tuned..we launch our beta POS Integration SDK for iOS early 2021 - email info@mywristcoin.com to enroll in the beta program. 
