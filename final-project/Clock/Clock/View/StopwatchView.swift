//
//  StopwatchView.swift
//  Clock
//
//  Created by Kate Murray on 4/17/24.
//

import SwiftUI

struct LapClass: Identifiable{
    var id = UUID()
    let lap: Double
    let num: Int
    init(_ lap: Double, _ num: Int){
        self.lap = lap
        self.num = num
    }
}

struct StopwatchView: View {
    
    @ObservedObject var managerClass = StopwatchClass()
    @State private var lapTimings: [LapClass] = []
    @State private var lapNum: Int = 1
    
    var body: some View {
        VStack {
            HStack{
                Text("\(managerClass.formattedMins < 10 ? "0" : "")\(String(Int((managerClass.formattedMins).rounded(.down)))):\(managerClass.formattedSecs < 10 ? "0" : "")\(String(format: "%.2f", managerClass.formattedSecs))")
                    .font(.custom("header", fixedSize: 80.0))
                                            .padding(.top, 100)
                                            .fontWeight(.thin)
//                if (managerClass.formattedMins < 10){
//                    Text("0")
//                        .font(.custom("header", fixedSize: 80.0))
//                        .padding(.top, 100)
//                        .fontWeight(.light)
//                }
//                Text(String(Int((managerClass.formattedMins).rounded(.down))))
//                    .font(.custom("header", fixedSize: 80.0))
//                    .padding(.top, 100)
//                    .fontWeight(.light)
//                Text(":")
//                    .font(.custom("header", fixedSize: 80.0))
//                    .padding(.top, 100)
//                    .fontWeight(.light)
//                if (managerClass.formattedSecs < 10){
//                    Text("0")
//                        .font(.custom("header", fixedSize: 80.0))
//                        .padding(.top, 100)
//                        .fontWeight(.light)
//                }
//                Text(String(format: "%.2f", managerClass.formattedSecs))
//                    .font(.custom("header", fixedSize: 80.0))
//                    .padding(.top, 100)
//                    .fontWeight(.light)
            }
            .padding(.bottom, 70)
            HStack{
                switch managerClass.mode {
                case .stopped:
                    withAnimation{
                        HStack{
                            
                            Button(action: {
                                managerClass.reset()
                                lapTimings = []
                                lapNum = 1
                            }, label: {
                                Text("Reset")
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
                            Button(action: { managerClass.start()},
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
                case .running:
                    withAnimation{
                        HStack{
                            ZStack{
                                    
                                Button(action: {
                                    let newLap = LapClass(managerClass.secondElapsed, lapNum)
                                    lapTimings.append(newLap)
                                    lapNum += 1
                                }, label: {
                                    Text("Lap")
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
                            Button(action: { managerClass.stop()},
                                   label: {Text("Stop")
                                    .font(.system(size: 20))
                                    .frame(width: 70, height: 100)
                                    .foregroundStyle(.red)
                                    .font(.title)
                                    .padding()
                                    .background(Color.red.opacity(0.2))
                                    .clipShape(Circle())
                            })
                            .padding(.trailing)
                        }
                    }
                }
            }
            List(lapTimings){ lap in
                HStack{
                    Text("Lap \(lap.num)")
                        .padding(.leading)
                    Spacer()
                    Text("\(String(format: "%.2f", lap.lap))")
                        .padding(.trailing)
                }
                .listRowSeparator(.visible)
                .listRowSeparatorTint(Color.white.opacity(0.2), edges: .all)
            }
            .listStyle(.inset)
            
        }
    }
}

enum stopwatchMode {
    case running
    case stopped
}

class StopwatchClass: ObservableObject {
    @Published var secondElapsed = 0.0
    @Published var mode: stopwatchMode = .stopped
    var timer = Timer()
    @Published var formattedMins = 0.0
    @Published var formattedSecs = 0.0

        
    func start() {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){ timer in
            self.secondElapsed += 0.01
            self.formattedSecs += 0.01
            if (self.formattedSecs > 60){
                self.formattedMins += 1 //self.secondElapsed / 60
                self.formattedSecs = 0
            }
        }
    }
    
    func stop(){
        timer.invalidate()
        mode = .stopped
    }
    
    func reset() {
        secondElapsed = 0.0
        formattedSecs = 0.0
        formattedMins = 0.0
    }
}

#Preview {
    StopwatchView()
}
