//
//  SelectMapVC.swift
//  GraduationProject
//
//  Created by OMER BUKTE on 5/10/18.
//  Copyright © 2018 Omer Bukte. All rights reserved.
//

import UIKit

class SelectMapVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mapOneTapped(_ sender: Any) {
        Variables.mapCode = 1
        performSegue(withIdentifier: "goToGame", sender: nil)
    }
    
    @IBAction func mapTwoTapped(_ sender: Any) {
        Variables.mapCode = 2
        performSegue(withIdentifier: "goToGame", sender: nil)
    }
    
    @IBAction func mapThreeTapped(_ sender: Any) {
        Variables.mapCode = 3
        performSegue(withIdentifier: "goToGame", sender: nil)
    }
    
    @IBAction func mapFourTapped(_ sender: Any) {
        Variables.mapCode = 4
        performSegue(withIdentifier: "goToGame", sender: nil)
    }
}
