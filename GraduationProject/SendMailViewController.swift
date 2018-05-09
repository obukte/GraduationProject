//
//  SendMailViewController.swift
//  GraduationProject
//
//  Created by OMER BUKTE on 5/9/18.
//  Copyright © 2018 Omer Bukte. All rights reserved.
//

import UIKit
import MessageUI

class SendMailViewController: UIViewController, MFMailComposeViewControllerDelegate {

    let composeVC = MFMailComposeViewController()
    override func viewDidLoad() {
        super.viewDidLoad()

        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["desiredEmail@gmail.com"])
        composeVC.setSubject("My message")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    

}
