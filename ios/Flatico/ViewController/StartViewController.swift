//
//  StartViewController.swift
//  Flatico
//
//  Created by Anthony Marchenko on 3/10/18.
//  Copyright © 2018 Anthony Marchenko. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    	super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func nextButtonDidPressed(_ sender: Any) {
        let mapViewController = storyboard?.instantiateViewController(withIdentifier: "mapViewControllerKey") as! MapViewController
        navigationController?.pushViewController(mapViewController,
                                                 animated: true)
    }
    
}
