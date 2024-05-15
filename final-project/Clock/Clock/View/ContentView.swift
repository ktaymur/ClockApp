//
//  ContentView.swift
//  Clock
//
//  Created by Kate Murray on 4/17/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
    
            AlarmView()
                .tabItem{
                    Label("Alarm", systemImage: "alarm")
                }
            StopwatchView()
                .tabItem {
                    Label("Stopwatch", systemImage: "stopwatch")
                }
            TestView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
        }
        .accentColor(.orange)
        .preferredColorScheme(.dark)
    }
}


#Preview {
    ContentView()
}
