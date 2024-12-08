//
//  ContentView.swift
//  DoroDoro
//
//  Created by Srijnasri on 08/12/24.
//

import SwiftUI

struct ContentView: View {
    @State var timerString: String
    @State var buttonType: ButtonState = .start
    @State var remainingSeconds = 25 * 60
    @State var timer: Timer?
    
    var body: some View {
        VStack {
            Text(timerString)
                .fontWeight(.bold)
                .font(.system(size: 40))
            HStack(spacing: 20) {
                Button(buttonType.rawValue, action: {
                    print("clicked")
                    switch buttonType {
                    case .start:
                        getTimerValue()
                    case .pause:
                        pauseTimer()
                    }
                })
                .font(.system(size: 20))
                .foregroundStyle(.black)
                .padding()
                .background(.gray, in: .capsule)
                Button {
                    resetTimer()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.black)
                }
            }
        }
        .padding()
    }
    
    func getTimerValue() {
        buttonType = .pause
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            remainingSeconds -= 1
            timerString = formatTime(seconds: remainingSeconds)
            if remainingSeconds == 0 {
                timer?.invalidate()
            }
        }
    }
    
    func pauseTimer() {
        timer?.invalidate()
        buttonType = .start
    }
    
    func resetTimer() {
        timer?.invalidate()
        buttonType = .start
        remainingSeconds = 25 * 60
        timerString = formatTime(seconds: remainingSeconds)
    }
    
    func formatTime(seconds: Int) -> String {
        let minutesLeft = seconds / 60
        let secondsLeft = seconds % 60
        return String(format: "%02d:%02d", minutesLeft, secondsLeft)
    }
}

enum ButtonState: String {
    case start
    case pause
}

#Preview {
    ContentView(timerString: "25:00")
}