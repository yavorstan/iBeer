//
//  BATimer.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 16.04.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class BATimerLabel: UILabel {
    
    var timer = Timer()
    var runningTime = Double()
    var remainingTime = Int()
    
    var completion: (() -> ())?
    
    var hours = Int()
    var minutes = Int()
    var seconds = Int()
    
    func startTimer(forSeconds runningTime: Double, completion: @escaping (() -> ())) {
        self.font = UIFont.defaultDescriptionFont.font
        
        self.completion = completion
        
        self.isHidden = false
        self.runningTime = runningTime
        self.remainingTime = Int(runningTime)
        
        hours = remainingTime / 3600
        minutes = (remainingTime % 3600) / 60
        seconds = (remainingTime % 3600) % 60
        self.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        
        timer.tolerance = 0.1
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            RunLoop.current.add(timer, forMode: .common)
            self.timerRepeats()
        }
    }
    
    @objc private func timerRepeats() {
        self.remainingTime -= 1
        
        hours = remainingTime / 3600
        minutes = (remainingTime % 3600) / 60
        seconds = (remainingTime % 3600) % 60
        self.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        
        if self.remainingTime <= 0 {
            self.completion?()
            self.isHidden = true
            timer.invalidate()
        }
    }
    
    func invalidate() {
        timer.invalidate()
    }
    
}
