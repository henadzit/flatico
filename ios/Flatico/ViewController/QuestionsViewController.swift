//
//  QuestionsViewController.swift
//  Flatico
//
//  Created by Anthony Marchenko on 3/11/18.
//  Copyright © 2018 Anthony Marchenko. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController {

    @IBOutlet weak var roomSlider: UISlider!
    @IBOutlet weak var floarSlider: UISlider!
    @IBOutlet weak var roomSquereTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        roomSlider.isContinuous = false
        floarSlider.isContinuous = false
        roomSquereTextField.delegate = self
        
        //Looks for single or multiple taps.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tapGesture)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func roomCountDidChanged(_ sender: UISlider) {
        print("\(sender.value)")
        QueryModel.shared.roomCount = Int(sender.value)
    }
    
    @IBAction func floorNumberDidChanged(_ sender: UISlider) {
        print("\(sender.value)")
        QueryModel.shared.floor = Int(sender.value)
    }
    
    @IBAction func isBalconyExistChangeValue(_ sender: UISwitch) {
        QueryModel.shared.isBalconExist = sender.isOn
    }
    
    @IBAction func nextButtonDidPressed(_ sender: UIButton) {
        let questionViewController = storyboard?.instantiateViewController(withIdentifier: "photoUploadViewControllerKey") as! PhotoUploadViewController
        navigationController?.pushViewController(questionViewController,
                                                 animated: true)
    }
    
}

extension QuestionsViewController : UITextFieldDelegate {
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        QueryModel.shared.roomCount = Int(textField.text!)!
        return true 
    }
}
