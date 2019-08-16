//
//  ViewController.swift
//  WaitingForConnectivityDemo
//
//  Created by Yuriy Zabroda on 8/16/19.
//  Copyright © 2019 Yuriy Zabroda. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleWaitingForConnectivity(_:)),
            name: .waitingForConnectivityNotification,
            object: nil
        )
    }


    @IBAction func doLoad(_ sender: UIButton) {
        WebServices.shared.callingApple { content, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.infoMessageLabel.text = error.localizedDescription
                }

                return
            }

            if let content = content {
                DispatchQueue.main.async {
                    self.infoMessageLabel.text = "Success!!!"
                    self.contentTextView.text = content
                }
            }
        }
    }


    @IBOutlet var infoMessageLabel: UILabel!
    @IBOutlet var contentTextView: UITextView!


    @objc func handleWaitingForConnectivity(_: Notification) {
        DispatchQueue.main.async {
            self.infoMessageLabel.text = "Waiting for connectivity..."
            self.contentTextView.text = ""
        }
    }
}
