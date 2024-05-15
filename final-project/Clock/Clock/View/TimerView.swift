//
//  TimerView.swift
//  Clock
//
//  Created by Kate Murray on 4/17/24.
//

import SwiftUI

struct TimerView: View {
    @State var timeRemaining = 10
    @State var minutes = 0.0
    @State var hours = 0.0
    @State var secs = 0.0
    @ObservedObject var managerClass = TimerClass()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack{
            
            HStack{
                switch managerClass.mode {
                case .start:
                    withAnimation{
                        VStack{
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
                                Picker("Minutes", selection: $secs){
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
                                    managerClass.cancel()
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
                                    managerClass.formattedHours = self.hours
                                    managerClass.formattedMins = self.minutes
                                    managerClass.formattedSecs = self.secs
                                    managerClass.start()},
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
                case .running:
                    withAnimation{
                        VStack {
                            HStack{
                                ZStack{
//                                    CircularProgressView(progress: (managerClass.formattedHours*60*60 + managerClass.formattedMins*60 + managerClass.formattedSecs))
                                    Text("\(managerClass.formattedHours):\(managerClass.formattedMins < 10 ? "0" : "")\(managerClass.formattedSecs):\(managerClass.formattedSecs < 10 ? "0" : "")\(managerClass.formattedSecs)")
                                        .font(.largeTitle)
                                        .padding()
                                        .frame(width: 300, height: 400)
                                }
                            }
                            
                            
                            HStack{
                                ZStack{
                                    
                                    Button(action: {
                                        managerClass.cancel()
                                        
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
                                    managerClass.pause()
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
                    Spacer()
                case .paused:
                    withAnimation{
                        VStack{
                            HStack{
                                ZStack{
//                                    CircularProgressView(progress: managerClass.secondElapsed)
                                    Text("\(managerClass.formattedHours): \(managerClass.formattedMins). \(managerClass.formattedSecs)")
                                        .frame(width: 300, height: 400)
                                }
                            }
                            HStack{
                                Button(action: { managerClass.cancel()},
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
                                Button(action: {managerClass.start()},
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
            }
        }
        
    }
}
        
                    
                    
    
    
//    enum timerMode {
//        case running
//        case paused
//        case start
//    }
    
    class TimerClass: ObservableObject {
        @Published var mode: timerMode = .start
        var timer = Timer()
        @Published var formattedMins: Double = 0.0
        @Published var formattedSecs: Double = 0.0
        @Published var formattedHours: Double = 0.0
        @Published var secondElapsed: Double = 0.0
        
        
        func start() {
            mode = .running
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){ timer in
                
                if (self.secondElapsed > 0){
                    self.secondElapsed -= 0.01
                    self.formattedSecs -= 0.01
                    if (self.formattedSecs > 60){
                        self.formattedMins += 1 //self.secondElapsed / 60
                        self.formattedSecs = 0
                    }
                }
            }
        }
        
        func pause(){
            timer.invalidate()
            mode = .paused
        }
        
        func cancel() {
            secondElapsed = 0.0
            formattedSecs = 0.0
            formattedMins = 0.0
            mode = .start
        }
        
        func run(){
            mode = .running
            start()
        }
    }

struct CircularProgressView: View {
    @State var progress: Double
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.orange.opacity(0.2),
                    lineWidth: 10
                )
                .frame(width: 350)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.orange,
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .round
                    )
                )
                .frame(width: 350)
                .rotationEffect(.degrees(-90))
                // 1
                .animation(.easeOut, value: progress)
        }
    }
    func update(){
        self.progress -= 1
    }
}


#Preview {
    TimerView()
}
