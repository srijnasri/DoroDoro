//
//  ContentView.swift
//  DoroDoro
//
//  Created by Srijnasri on 08/12/24.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @State var timerString: String
    @State var buttonType: ButtonState = .start
    @State var timer: Timer?
    @State var timerState: TimerState = .work
    @State var isToggleOn : Bool = true
    @State var remainingSeconds = 25 * 60
    @State var audioPlayer: AVAudioPlayer?
    @State var musicType: MusicType = .focus
    
    var body: some View {
        VStack(spacing: 20) {
            Toggle(isOn: $isToggleOn) {
                Label(timerState.rawValue, systemImage: timerState.toggleImage)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.black)
            }
            .toggleStyle(.button)
            // on basis of toggle we are trying to update the view
            .onChange(of: isToggleOn) { oldValue, newValue in
                if oldValue {
                    // meaning work
                    timerState = .break
                    resetTimer()
                } else {
                    // meaning break
                    timerState = .work
                    resetTimer()
                }
            }
            Text(timerString)
                .fontWeight(.bold)
                .font(.system(size: 40))
            HStack(spacing: 20) {
                Button(buttonType.rawValue, action: {
                    switch buttonType {
                    case .start:
                        getTimerValue()
                            // play audio
                        playAudio(musicType: .focus, onRepeat: true)
                    case .pause:
                        pauseTimer()
                        stopMusic()
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
                resetTimer()
                // insert complete focus time celebration logic
                stopMusic()
                playAudio(musicType: .finish, onRepeat: false)
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
        remainingSeconds = timerState.remainingSeconds
        timerString = formatTime(seconds: remainingSeconds)
    }
    
    func formatTime(seconds: Int) -> String {
        let minutesLeft = seconds / 60
        let secondsLeft = seconds % 60
        return String(format: "%02d:%02d", minutesLeft, secondsLeft)
    }
    
    func playAudio(musicType: MusicType, onRepeat: Bool) {
        if let audioUrl = Bundle.main.url(forResource: musicType.rawValue, withExtension: ".mp3") {
            if let audioPlayer = try? AVAudioPlayer(contentsOf: audioUrl) {
                self.audioPlayer = audioPlayer
                self.audioPlayer?.numberOfLoops = onRepeat ? -1 : 0
                self.audioPlayer?.play()
            }
        }
    }
    
    func stopMusic() {
        audioPlayer?.stop()
    }
}

enum ButtonState: String {
    case start
    case pause
}

enum TimerState: String {
    case work
    case `break`
    
    var toggleImage: String {
        switch self {
        case .work:
            "desktopcomputer"
        case .break:
            "zzz"
        }
    }
    
    var remainingSeconds: Int {
        switch self {
        case .work:
            25 * 60
        case .break:
            5 * 60
        }
    }
}

enum MusicType: String {
    case focus = "focus_music"
    case fun = "fun_music"
    case finish = "finish_music"
    case tap = "sound_effect"
}


#Preview {
    ContentView(timerString: "25:00")
}
