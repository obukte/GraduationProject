//
//  MainMenuVC.swift
//  GraduationProject
//
//  Created by OMER BUKTE on 5/10/18.
//  Copyright © 2018 Omer Bukte. All rights reserved.
//

import UIKit

class MainMenuVC: UIViewController {

    @IBOutlet weak var subjectID: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        
        if subjectID.text == "" {
            let alert = UIAlertController(title: "Error", message: "Enter the Subject ID!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else {
            Variables.experimenterID = subjectID.text!
            performSegue(withIdentifier: "goToMapSelect", sender: nil)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
