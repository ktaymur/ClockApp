//
//  AlarmView.swift
//  Clock
//
//  Created by Kate Murray on 4/17/24.
//

import SwiftUI
import UserNotifications

// MARK: - Model
struct Alarm: Identifiable {
    let id = UUID()
    var time: Date
    var enabled: Bool
    var type: String
}

// MARK: - Alarm Manager
class AlarmManager: ObservableObject {
    @Published var alarms: [Alarm] = []
    
    func addAlarm(alarm: Alarm) {
        alarms.append(alarm)
        scheduleNotification(for: alarm)
    }
    
    func updateAlarm(alarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index] = alarm
            cancelNotification(for: alarm)
            if alarm.enabled{
                scheduleNotification(for: alarm)
            }
        }
    }
    
    func deleteAlarm(at index: Int) {
        let alarm = alarms.remove(at: index)
        cancelNotification(for: alarm)
    }
    
    private func scheduleNotification(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = "Wake up!"
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: alarm.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: alarm.id.uuidString, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()

        notificationCenter.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    }
                }
    }
    
    private func cancelNotification(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.id.uuidString])
    }
}

// MARK: - Views
struct AlarmView: View {
    @StateObject var alarmManager = AlarmManager()
    @State private var showingAddAlarmSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Button(action: {}, label: {Text("Edit")})
                        .foregroundStyle(.orange)
                        .font(.title)
                        .padding(.leading)
                    Spacer()
                    Text("Alarm")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Spacer()
                    Button{ showingAddAlarmSheet.toggle() } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.orange)
                            .font(.largeTitle)
                        .padding(.trailing)}
                    
                }
                
                
                List {
                    ForEach(alarmManager.alarms) { alarm in
                        AlarmRowView(alarmManager: alarmManager, alarm: alarm)
                    }
                    .onDelete(perform: deleteAlarm)
                    .listRowSeparator(.visible)
                    .listRowSeparatorTint(Color.white.opacity(0.2), edges: .all)
                }
                .listStyle(.inset)
                
            }
            .sheet(isPresented: $showingAddAlarmSheet) {
                AddAlarmView(alarmManager: alarmManager)
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
                if success {
                        print("Permission granted")
                    } else if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
            }
        }
    }
    
    private func deleteAlarm(at offsets: IndexSet) {
        offsets.forEach { index in
            alarmManager.deleteAlarm(at: index)
        }
    }
}

struct AlarmRowView: View {
    @ObservedObject var alarmManager: AlarmManager
    @State var alarm: Alarm
    
    var body: some View {
        Toggle(isOn: $alarm.enabled) {
            if (!alarm.enabled){
                Text(alarmTime)
                    .font(.largeTitle)
                    .foregroundStyle(.white.opacity(0.5))
                if (alarm.type != "") {
                    Text("\(alarm.type)")
                        .foregroundStyle(.white.opacity(0.5))
                } else {
                    Text("Alarm")
                        .foregroundStyle(.white.opacity(0.5))
                }
            }else {
                Text(alarmTime)
                        .font(.largeTitle)
                        if (alarm.type != "") {
                            Text("\(alarm.type)")
                                .foregroundStyle(.white)
                        } else {
                            Text("Alarm")
                                .foregroundStyle(.white)
                        }
            }
        }
        .onChange(of: alarm.enabled) { _ in
            alarmManager.updateAlarm(alarm: alarm)
        }
        .padding([.top, .bottom])
        
        var alarmTime: String {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: alarm.time)
        }
    }
}

struct AddAlarmView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var alarmTime = Date()
    @ObservedObject var alarmManager: AlarmManager
    @State private var alarmType: String = ""

    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    Button("Cancel"){
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundStyle(.orange)
                    .padding(.leading)
                    Spacer()
                    Text("Add Alarm")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Button("Save") {
                        let alarm = Alarm(time: alarmTime, enabled: true, type: alarmType)
                        alarmManager.addAlarm(alarm: alarm)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundStyle(.orange)
                    .padding(.trailing)
                }
                .padding(.top, 30)
                Spacer()
                DatePicker("", selection: $alarmTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                Form{
                    HStack{
                        Text("Label")
                        TextField("Alarm", text: $alarmType)
                            .multilineTextAlignment(.trailing)
                    }
                    
                }
            }

        }
    }
}

// MARK: - Preview
#Preview{
    AlarmView()
}
