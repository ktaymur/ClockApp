//
//  TestView.swift
//  Clock
//
//  Created by Kate Murray on 4/21/24.
//

import SwiftUI
import UserNotifications

enum timerMode {
    case running
    case paused
    case start
}

struct TestView: View {
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0
    @State private var timerIsRunning = false
    @State private var timer: Timer?
    @State private var ticks = 0
    @State private var showNotification = false


    @State var mode: timerMode = .start
    
    var totalTimeInSeconds: Int {
        let hours = hours
        let minutes = minutes
        let seconds = seconds
        return hours * 3600 + minutes * 60 + seconds
    }
        
    var elapsedTimeInSeconds: Int {
        return hours * 3600 + minutes * 60 + seconds
    }
        
        var progress: Double {
            if totalTimeInSeconds == 0 {
                return 0
            } else {
                return Double(elapsedTimeInSeconds) / Double(totalTimeInSeconds)
            }
        }
    
    var body: some View {
        VStack{
            if mode == .start{
                startView()
            }
            else if mode == .running{
                runningView()
            }
            else{
                pausedView()
            }
        }
        .alert(isPresented: $showNotification) {
            Alert(title: Text("Timer Finished"), message: Text("Your timer is up"), dismissButton: .default(Text("OK")))
        }
    }
    
    
    func startTimer() {
        self.mode = .running
        if !timerIsRunning {
            timerIsRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if self.hours == 0 && self.minutes == 0 && self.seconds == 0 {
                    showNotification = true
                    self.resetTimer()
                } else if self.seconds == 0 {
                    if self.minutes == 0 {
                        self.hours -= 1
                        self.minutes = 59
                    } else {
                        self.minutes -= 1
                    }
                    self.seconds = 59
                } else {
                    self.seconds -= 1
                }
            }
        }
    }
    
//    func scheduleNotification() {
//        let content = UNMutableNotificationContent()
//        content.title = "Timer Finished"
//        content.body = "Your timer has reached 0"
//        content.sound = UNNotificationSound.default
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) // Trigger the notification immediately
//        let request = UNNotificationRequest(identifier: "timerFinished", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Error scheduling notification: \(error.localizedDescription)")
//            } else {
//                print("Notification scheduled successfully")
//            }
//        }
//    }
    
    func stopTimer() {
        mode = .paused
        timerIsRunning = false
        timer?.invalidate()
    }
    
    
    func resetTimer() {
        mode = .start
        timerIsRunning = false
        timer?.invalidate()
        hours = 0
        minutes = 0
        seconds = 0
    }
    
    private func startView() -> some View {
        VStack {
            HStack{
                Picker("Hours", selection: $hours){
                    ForEach(0..<24){ num in
                        Text(String(num))}
                }
                .pickerStyle(.wheel)
                .padding(.trailing, -15)
                .clipped()
                
                Text("hours")
                    .fontWeight(.bold)
                    .padding(.leading, -20)
                
                
                Picker("Minutes", selection: $minutes){
                    ForEach(0..<60){ num in
                        Text(String(num))}
                }
                .pickerStyle(.wheel)
                .padding(.horizontal, -15)
                .clipped()
                Text("min")
                    .fontWeight(.bold)
                    .padding(.leading, -20)
                Picker("Minutes", selection: $seconds){
                    ForEach(0..<60){ num in
                        Text(String(num))}
                }
                .pickerStyle(.wheel)
                .padding(.leading, -15)
                .clipped()
                
                Text("sec")
                    .fontWeight(.bold)
                    .padding(.leading, -20)
                    .padding(.trailing, 30)
            }
            .compositingGroup()
            
            HStack{
                Button(action: {
                    self.resetTimer()
                }, label: {
                    Text("Cancel")
                        .font(.system(size: 20))
                        .frame(width: 70, height: 100)
                        .foregroundStyle(.white)
                        .font(.title)
                        .padding()
                        .background(Color.white.opacity(0.15))
                        .clipShape(Circle())
                })
                .padding(.leading)
                Spacer()
                Button(action: {
                    self.startTimer()
                },
                       label: {Text("Start")
                        .font(.system(size: 20))
                        .frame(width: 70, height: 100)
                        .foregroundStyle(.green)
                        .font(.title)
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .clipShape(Circle())
                })
                .padding(.trailing)
            }
        }
    }
    
    @ViewBuilder
    private func runningView() -> some View {
        VStack {
//            Text("\(elapsedTimeInSeconds)")

            HStack{
                ZStack{
                    CircularProgressView(progress: progress)
                    Text("\(hours):\(minutes < 10 ? "0" : "")\(minutes):\(seconds < 10 ? "0" : "")\(seconds)")
                        .font(.largeTitle)
                        .padding()
                    
                }
            }
            
            
            HStack{
                ZStack{
                    
                    Button(action: {
                        self.resetTimer()
                        
                    }, label: {
                        Text("Cancel")
                            .font(.system(size: 20))
                            .frame(width: 70, height: 100)
                            .foregroundStyle(.white)
                            .font(.title)
                            .padding()
                            .background(Color.white.opacity(0.15))
                            .clipShape(Circle())
                        
                    })
                    .padding(.leading)
                    
                }
                Spacer()
                Button(action: {
                    self.stopTimer()
                },
                       label: {Text("Pause")
                        .font(.system(size: 20))
                        .frame(width: 70, height: 100)
                        .foregroundStyle(.orange)
                        .font(.title)
                        .padding()
                        .background(Color.orange.opacity(0.2))
                        .clipShape(Circle())
                })
                .padding(.trailing)
            }
        }
    }
    
    @ViewBuilder
    private func pausedView() -> some View {
        VStack {
//            Text("\(self.elapsedTimeInSeconds)")
//            Text("\(self.totalTimeInSeconds)")
            HStack{
                ZStack{
                    CircularProgressView(progress: progress)
                    Text("\(hours):\(minutes < 10 ? "0" : "")\(minutes):\(seconds < 10 ? "0" : "")\(seconds)")
                        .font(.largeTitle)
                        .padding()
                }
            }
            HStack{
                Button(action: {self.resetTimer()
                },
                       label: {Text("Cancel")
                        .font(.system(size: 20))
                        .frame(width: 70, height: 100)
                        .foregroundStyle(.white)
                        .font(.title)
                        .padding()
                        .background(Color.white.opacity(0.15))
                        .clipShape(Circle())
                })
                .padding(.leading)
                
                Spacer()
                Button(action: {self.startTimer()
                },
                       label: {Text("Resume")
                        .font(.system(size: 19))
                        .frame(width: 70, height: 100)
                        .foregroundStyle(.green)
                        .font(.title)
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .clipShape(Circle())
                })
                .padding(.trailing)
            }
        }
        
    }
}


#Preview {
    TestView()
}
