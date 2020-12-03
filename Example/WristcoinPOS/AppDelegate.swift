//
//  AppDelegate.swift
//  WristcoinPOS
//
//  Created by David Shalaby on 11/28/2020.
//  Copyright (c) 2020 Wristcoin Inc. All rights reserved.
//

import UIKit
import CoreBluetooth
import TCMPTappy
import WristcoinPOS

/*
Todo: Make a simple UI for this example.  At the moment this is just a simple example of how to connect to the Wristcoin Bluetooth terminal and perform some operations:
 (1) Set the event id - at the moment Wristcoin terminals are pre-configured at the factory for your event(s) you specify when ordering the terminals.
     Setting the event id selects the event your POS is using.  Passing an event id that the terminal was not configured for at the factory will result
     in an error returned from the Wristcoin terminal.
 (2) Read a wristband status - there is the option to send it with a specified timeout or not.  If no timeout is specified the terminal will use a default
     timeout of about eight seconds or so.
     Note: Specifying a timeout is interpreted as seconds from 0-255 seconds, 0 indicating no timeout (poll for a wristband until interrupted).
 (3) Debit a wristband one centavo (0.01) of credit - first only requesting a short response from the terminal (only returns the remaining balance)
 (4) Debit a wristband one centavo (0.01) of credit - this time requesting a full response from the terminal (returns same data as GetWristbandStatusCommand)
*/
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var scanner : TappyBleScanner = TappyBleScanner(centralManager: TappyCentralManagerProvider.shared().centralManager)
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        scanner.setStatusListener(statusReceived: myWCTerminalScannerStatusListener)
        scanner.setTappyFoundListener(listener: myWCTerminalFoundListner)
        NSLog("Listeners set, attempting to start scan")

        if (scanner.getState() == TappyBleScannerStatus.STATUS_POWERED_ON){
            if scanner.startScan(){
                NSLog("Scan for Wristcoin Bluetooth terminals initiated")
            }else{
                NSLog("Failed to initiate scan for Wristcoin Bluetooth terminals")
            }
        }
        return
    }
       
    func myWCTerminalScannerStatusListener(status : TappyBleScannerStatus){
        NSLog(String(format: "Wristcoin Bluetooth terminal scanner status has been reported"))
    }

    func myWCTerminalFoundListner(tappyDevice : TappyBleDevice){
         NSLog(String(format: "Found a Wristcoin terminals named %@", arguments: [tappyDevice.name()]))
        scanner.stopScan()
        if let tappyBle = TappyBle.getTappyBle(centralManager: TappyCentralManagerProvider.shared().centralManager, device: tappyDevice){
            WristcoinTerminalManager.shared().tappyBle = tappyBle
            WristcoinTerminalManager.shared().tappyBle?.setStatusListener(listener: myWCTerminalStatusListener)
            tappyBle.connect()
        }else{
            NSLog(String(format: "Failed to initialize the TappyBleCommunicator with peripheral %@ with ID %@", arguments: [tappyDevice.deviceName,String(describing :tappyDevice.deviceId)]))
        }
    }

    func myWCTerminalStatusListener(status : TappyStatus){
        NSLog(String(format: "Tappy status %@ has been reported", arguments: [status.getString()]))
        if (status == TappyStatus.STATUS_READY){
            WristcoinTerminalManager.shared().tappyBle?.setResponseListener(listener: myWCTerminalResponseListener)
            NSLog("Wristcoin Terminal connected, setting the event id")
            var setEventIdCmd: SetEventIdCommand
            /*Use your own Wristcoin event id here*/
            try! setEventIdCmd = SetEventIdCommand(eventId: [0xA6, 0x49, 0xE0, 0xF4, 0x0B, 0xC0, 0x11, 0xEA, 0x84, 0xD8, 0xAF, 0xBA, 0xB2, 0xCF, 0xCB, 0x2A])
            WristcoinTerminalManager.shared().tappyBle?.sendMessage(message: setEventIdCmd)
        }
    }

    func myWCTerminalResponseListener(tcmpResponse : TCMPMessage){
        NSLog("Received a valid message from a Tappy")
        var response : TCMPMessage
        do{
            try response = WristcoinPOSCommandResolver.resolveResponse(message: tcmpResponse)
            if(response is SetEventIdResponse){
                NSLog("Event id set, now getting wristband status....")
                /*Time to remove the wristband for testing/eval purposes*/
                sleep(2)
                let getWristbandStatusCmd : GetWristbandStatusCommand = GetWristbandStatusCommand()
                /*Uncomment the two lines below in favour of the above to try with a timeout*/
//                let getWristbandStatusCmd : GetWristbandStatusCommand
//                try! getWristbandStatusCmd = GetWristbandStatusCommand(timeout: 0)
                WristcoinTerminalManager.shared().tappyBle?.sendMessage(message: getWristbandStatusCmd)
            }else if(response is GetWristbandStatusResponse){
                NSLog(String(format: "Wristband status recieved with TLV array %@", arguments:[response.payload]))
                NSLog("Now attempting to debit one centavo (0.01) of credit....")
                sleep(2)
                let  debitWristbandShortRespCmd : DebitWristbandShortRespCommand
                try! debitWristbandShortRespCmd = DebitWristbandShortRespCommand(debitAmountCentavos: 1)
                /*Uncomment the two lines below in favour of the above to try with a timeout*/
//                try! debitWristbandShortRespCmd = DebitWristbandShortRespCommand(debitAmountCentavos: 1, timeout: 0)
                WristcoinTerminalManager.shared().tappyBle?.sendMessage(message: debitWristbandShortRespCmd)
            }else if(response is DebitWristbandShortRespResponse){
                let remainingBalance : Int32 = Int32(bigEndian: Data(bytes: response.payload).withUnsafeBytes { $0.pointee })
                NSLog(String(format: "Wristband debitted with short response, remaining balance is %@", arguments:[String(remainingBalance)]))
                NSLog("Now attempting to debit one centavo (0.01) of credit with full response....")
                sleep(2)
                let  debitWristbandFullRespCmd : DebitWristbandFullRespCommand
                try! debitWristbandFullRespCmd = DebitWristbandFullRespCommand(debitAmountCentavos: 1)
                /*Uncomment the two lines below in favour of the above to try with a timeout*/
//                try! debitWristbandFullRespCmd = DebitWristbandFullRespCommand(debitAmountCentavos: 1,timeout: 0)
                WristcoinTerminalManager.shared().tappyBle?.sendMessage(message: debitWristbandFullRespCmd)
            }else if(response is DebitWristbandFullRespResponse){
                NSLog(String(format: "Wristband debitted with full response TLV array %@", arguments:[response.payload]))
                NSLog("This is the end of this example program")
            }else if(response is GetWristcoinPOSCommandFamilyVersionResponse){
                NSLog(String(format: "Command family version is %@", arguments:[response.payload]))
            }else if (response is WristcoinPOSApplicationErrorMessage){
                let errMsg : WristcoinPOSApplicationErrorMessage = response as! WristcoinPOSApplicationErrorMessage
                NSLog(String(format: "Wristcoin POS error: %@", arguments:[errMsg.errorDescription]))
                NSLog("Getting wristband status again...")
                let getWristbandStatusCmd : GetWristbandStatusCommand = GetWristbandStatusCommand()
                WristcoinTerminalManager.shared().tappyBle?.sendMessage(message: getWristbandStatusCmd)
           }else{
                NSLog("Response is something else")
            }
        }catch{
            NSLog("Message resolution failed")
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {      
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}
