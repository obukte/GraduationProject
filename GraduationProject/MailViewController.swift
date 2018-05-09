//
//  MailViewController.swift
//  GraduationProject
//
//  Created by OMER BUKTE on 5/9/18.
//  Copyright © 2018 Omer Bukte. All rights reserved.
//

import UIKit
import MessageUI

class MailViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mailComposeViewController = configureMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            self.showSendMailErrorAlert()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self as! MFMailComposeViewControllerDelegate
        mailComposerVC.setToRecipients(["omer.bukte@ozu.edu.tr"])
        mailComposerVC.setSubject("Experiment Data")
        mailComposerVC.setMessageBody("Experiment Data is attached.", isHTML: false)
        
        let fileName = "myFileName.txt"
        var filePath = ""
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        let dir = dirs[0]
        filePath = dir.appending("/" + fileName)
        
        if let fileData = NSData(contentsOfFile: filePath) {
            mailComposerVC.addAttachmentData(fileData as Data, mimeType: "text/txt", fileName: "myFileName")
        }
        mailComposeController(controller: mailComposerVC, didFinishWithResult: nil, error: nil)
        return mailComposerVC
    }
    
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send the mail.", message: "Your device could not send the mail.", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismiss(animated: true, completion: nil)
        
    }

}
