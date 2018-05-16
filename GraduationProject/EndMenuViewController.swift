//
//  EndMenuViewController.swift
//  GraduationProject
//
//  Created by OMER BUKTE on 5/9/18.
//  Copyright © 2018 Omer Bukte. All rights reserved.
//

import UIKit
import MessageUI

class EndMenuViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendDataButtonTapped(_ sender: Any) {
        
        let mailComposeViewController = configureMailComposeViewController()

        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            self.showSendMailErrorAlert()
        }
        
    }
    
    func configureMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([""])
        mailComposerVC.setSubject("Experiment Data of Subject \(Variables.experimenterID)")
        mailComposerVC.setMessageBody("Subject \(Variables.experimenterID) experiment data is attached.", isHTML: false)
        
        let fileName = "subject_\(Variables.experimenterID)_Map\(Variables.mapCode)_Data.txt"
        let highScoreName = "subject_\(Variables.experimenterID)_Map\(Variables.mapCode)_Scores.txt"
        var filePath = ""
        var filePathScores = ""
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        let dir = dirs[0]
        let dirTwo = dirs[0]
        filePath = dir.appending("/" + fileName)
        filePathScores = dirTwo.appending("/" + highScoreName)
        if let fileData = NSData(contentsOfFile: filePath) {
            mailComposerVC.addAttachmentData(fileData as Data, mimeType: "text/txt", fileName: "subject_\(Variables.experimenterID)_Map\(Variables.mapCode)_Data.txt")
        }
        if let fileData = NSData(contentsOfFile: filePathScores) {
            mailComposerVC.addAttachmentData(fileData as Data, mimeType: "text/txt", fileName: "subject_\(Variables.experimenterID)_Map\(Variables.mapCode)_Scores.txt")
        }
        
        return mailComposerVC
    }
    
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send the mail.", message: "Your device could not send the mail.", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
