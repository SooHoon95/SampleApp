//
//  ViewController.swift
//  LEDBoard
//
//  Created by 최수훈 on 2022/11/13.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var contentsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentsLabel.textColor = .yellow
    }


}

