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
    var timerString = "00:00"
    var onTick: (() -> Void)?
    
    init() {
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer?.schedule(deadline: .now() + 1, repeating: 1)
        timer?.setEventHandler { [weak self] in
            self?.timerTicks()
        }
        status = .ticking
        timer?.resume()
    }
    
    private func timerTicks() {
        seconds += 1
        let minutes = seconds / 60
        let secondsOnTimer = seconds % 60
        timerString = String(format: "%02d:%02d", minutes, secondsOnTimer)
        onTick?()
    }
    
    func suspend() {
        if status == .suspended { return }
        status = .suspended
        timer?.suspend()
    }
    
    func resume() {
        if status == .ticking { return }
        status = .ticking
        timer?.resume()
    }
    
    func deactivate() {
        if status == .canceled { return }
        status = .canceled
        resume()
        timer?.cancel()
        timer = nil
    }
    
    deinit {
        deactivate()
    }
}
