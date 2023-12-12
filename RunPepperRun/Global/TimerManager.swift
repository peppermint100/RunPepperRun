//
//  TimerManager.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/12/23.
//

import UIKit

enum TimerStatus {
    case canceled, suspended, ticking
}

class TimerManager {
    var timer: DispatchSourceTimer?
    var seconds = 0
    var status: TimerStatus = .canceled
    
    init(label: UILabel) {
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer?.schedule(deadline: .now() + 1, repeating: 1)
        timer?.setEventHandler { [weak self] in
            self?.updateLabel(label)
        }
        status = .ticking
        timer?.resume()
    }
    
    func updateLabel(_ label: UILabel) {
        seconds += 1
        let minutes = seconds / 60
        let secondsOnTimer = seconds % 60
        label.text = String(format: "%02d:%02d", minutes, secondsOnTimer)
    }
    
    func suspend() {
        status = .suspended
        timer?.suspend()
    }
    
    func resume() {
        status = .ticking
        timer?.resume()
    }
    
    func deactivate() {
        resume()
        status = .canceled
        timer?.cancel()
        timer = nil
    }
    
    deinit {
        deactivate()
    }
}
