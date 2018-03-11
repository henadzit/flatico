//
//  FinalViewController.swift
//  Flatico
//
//  Created by Anthony Marchenko on 3/11/18.
//  Copyright © 2018 Anthony Marchenko. All rights reserved.
//

import UIKit

class FinalViewController: UIViewController {

    @IBOutlet weak var finalFlatPriceLabel: UILabel!
    var finalPriceValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        finalFlatPriceLabel.text = "$\(finalPriceValue)"
    }
    
    @IBAction func resetButtonDidPrssed(_ sender: UIButton) {
        QueryModel.shared.resetToDefault()
        navigationController?.popToRootViewController(animated: true)
    }
    
}
