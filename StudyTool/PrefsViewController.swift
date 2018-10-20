//
//  PrefsViewController.swift
//  StudyTool
//
//  Created by Aaron Walker on 20/10/2018.
//  Copyright © 2018 Aaron Walker. All rights reserved.
//

import Cocoa

class PrefsViewController: NSViewController {

    @IBOutlet weak var presetsPopup: NSPopUpButton!
    @IBOutlet weak var customSlider: NSSlider!
    @IBOutlet weak var customTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func popupValueChanged(_ sender: Any) {
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
    }
    
    @IBAction func okButtonClicked(_ sender: Any) {
    }
}
