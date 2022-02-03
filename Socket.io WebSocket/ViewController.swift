//
//  ViewController.swift
//  Socket.io WebSocket
//
//  Created by Krishna Suravarapu on 02/02/22.
//

import UIKit
import SocketIO

class ViewController: UIViewController, UIAlertViewDelegate {

    let manager = SocketManager(socketURL: URL(string: ProcessInfo.processInfo.arguments[1])!, config: [.log(true), .forcePolling(true), .forceWebsockets(false), .compress])
    
    var socket:SocketIOClient!
    
    var isConnected = false

    override func viewDidLoad() {
        super.viewDidLoad()
        socket = manager.defaultSocket
        addHandlers()
    }
    
    func addHandlers() {
        
        socket.on("text") {[weak self] data, ack in
            if let alertMessage = data[0] as? String {
                self?.displayAlert(alertMessage: alertMessage)
            }
            return
        }
        
        socket.on(clientEvent: .disconnect, callback: { data, ack in
            print("SocketManager: disconnected")
            self.isConnected = false
            self.displayAlert(alertMessage: "Disconnected")
        })
        
        socket.on(clientEvent: .connect, callback: { data, ack in
            print("SocketManager: connected")
            self.isConnected = true
            self.displayAlert(alertMessage: "Connected")
        })
    }
    
    @IBAction func connectToggle(_ sender: UIBarButtonItem) {
        if isConnected {
            sender.title = "Connect"
            socket.disconnect()
        } else {
            sender.title = "Disconnect"
            socket.connect()
        }
    }
    
    @IBAction func sendMessage(_ sender: UIBarButtonItem) {
        socket.emit("message", "Request")
    }
    
    func displayAlert(alertMessage: String) {
        let alert = UIAlertController(title: "Response", message: alertMessage, preferredStyle: UIAlertController.Style.alert)

                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                // show the alert
                self.present(alert, animated: true, completion: nil)
    }

}

