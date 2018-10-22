//
//  ViewController.swift
//  StudyTool
//
//  Created by Aaron Walker on 19/10/2018.
//  Copyright © 2018 Aaron Walker. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {
    
    @IBOutlet weak var timeLeftField: NSTextField!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var resetButton: NSButton!
    
    var studyTimer = StudyTimer()
    var prefs = Preferences()
    var soundPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studyTimer.delegate = self
        setupPrefs()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func startButtonClicked(_ sender: Any) {
        if studyTimer.isPaused {
            studyTimer.resumeTimer()
        } else {
            studyTimer.duration = prefs.selectedTime
            studyTimer.startTimer()
        }
        prepareSound()
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        studyTimer.stopTimer()
    }
    
    @IBAction func resetButtonClicked(_ sender: Any) {
        studyTimer.resetTimer()
        updateDisplay(for: prefs.selectedTime)
    }
    
    // MARK: - IBActions - menus
    
    @IBAction func startTimerMenuItemSelected(_ sender: Any) {
        startButtonClicked(sender)
        configureButtonsAndMenus()
    }
    
    @IBAction func stopTimerMenuItemSelected(_ sender: Any) {
        stopButtonClicked(sender)
        configureButtonsAndMenus()
    }
    
    @IBAction func resetTimerMenuItemSelected(_ sender: Any) {
        resetButtonClicked(sender)
        configureButtonsAndMenus()
    }


}

extension ViewController: StudyTimerProtocol {
    
    func timeRemainingOnTimer(_ timer: StudyTimer, timeRemaining: TimeInterval) {
        updateDisplay(for: timeRemaining)
    }
    
    func timerHasFinished(_ timer: StudyTimer) {
        updateDisplay(for: 0)
        playSound()
    }
}

extension ViewController {
    
    // MARK: - Display
    
    func updateDisplay(for timeRemaining: TimeInterval) {
        timeLeftField.stringValue = textToDisplay(for: timeRemaining)
    }
    
    private func textToDisplay(for timeRemaining: TimeInterval) -> String {
        if timeRemaining == 0 {
            return "Done!"
        }
        
        let minutesRemaining = floor(timeRemaining / 60)
        let secondsRemaining = timeRemaining - (minutesRemaining * 60)
        
        let secondsDisplay = String(format: "%02d", Int(secondsRemaining))
        let timeRemainingDisplay = "\(Int(minutesRemaining)):\(secondsDisplay)"
        
        return timeRemainingDisplay
    }
    
    func configureButtonsAndMenus() {
        let enableStart: Bool
        let enableStop: Bool
        let enableReset: Bool
        
        if studyTimer.isStopped {
            enableStart = true
            enableStop = false
            enableReset = false
        } else if studyTimer.isPaused {
            enableStart = true
            enableStop = false
            enableReset = true
        } else {
            enableStart = false
            enableStop = true
            enableReset = false
        }
        
        startButton.isEnabled = enableStart
        stopButton.isEnabled = enableStop
        resetButton.isEnabled = enableReset
        
        if let appDel = NSApplication.shared.delegate as? AppDelegate {
            appDel.enableMenus(start: enableStart, stop: enableStop, reset: enableReset)
        }
    }
    
    //Remove if no image is used
    private func imageToDisplay(for timeRemaining: TimeInterval) -> NSImage? {
        let percentageComplete = 100 - (timeRemaining / prefs.selectedTime * 100)
        
        if studyTimer.isStopped {
            let stoppedImageName = (timeRemaining == 0) ? "100" : "stopped"
            return NSImage(named: stoppedImageName)
        }
        
        let imageName: String
        switch percentageComplete {
        case 0 ..< 25:
            imageName = "0"
        case 25 ..< 50:
            imageName = "25"
        case 50 ..< 75:
            imageName = "50"
        case 75 ..< 100:
            imageName = "75"
        default:
            imageName = "100"
        }
        
        return NSImage(named: imageName)
    }
    
}

extension ViewController {
    
    // MARK: - Preferences
    
    func setupPrefs() {
        updateDisplay(for: prefs.selectedTime)
        
        let notificationName = Notification.Name(rawValue: "PrefsChanged")
        NotificationCenter.default.addObserver(forName: notificationName,
                                               object: nil, queue: nil) {
                                                (notification) in
                                                self.checkForResetAfterPrefsChange()
        }
    }
    
    func updateFromPrefs() {
        self.studyTimer.duration = self.prefs.selectedTime
        self.resetButtonClicked(self)
    }
    
    func checkForResetAfterPrefsChange() {
        if studyTimer.isStopped || studyTimer.isPaused {
            // 1
            updateFromPrefs()
        } else {
            // 2
            let alert = NSAlert()
            alert.messageText = "Reset timer with the new settings?"
            alert.informativeText = "This will stop your current timer!"
            alert.alertStyle = .warning
            
            // 3
            alert.addButton(withTitle: "Reset")
            alert.addButton(withTitle: "Cancel")
            
            // 4
            let response = alert.runModal()
            if response == NSApplication.ModalResponse.alertFirstButtonReturn {
                self.updateFromPrefs()
            }
        }
    }
}

extension ViewController {
    
    // MARK: - Sound
    
    func prepareSound() {
        guard let audioFileUrl = Bundle.main.url(forResource: "ding",
                                                 withExtension: "mp3") else {
                                                    return
        }
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
            soundPlayer?.prepareToPlay()
        } catch {
            print("Sound player not available: \(error)")
        }
    }
    
    func playSound() {
        soundPlayer?.play()
    }
    
}


