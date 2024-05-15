//
//  Test2.swift
//  Clock
//
//  Created by Kate Murray on 4/22/24.
//
//import SwiftUI
//
//struct WorldClockView: View {
//    @State private var time: String = ""
//
//    let cities = [
//        ("New York", "America/New_York"),
//        ("London", "Europe/London"),
//        ("Tokyo", "Asia/Tokyo"),
//        // Add more cities as needed
//    ]
//
//    var body: some View {
//        VStack {
//            Text("World Clock")
//                .font(.largeTitle)
//                .padding()
//
//            Spacer()
//
//            ForEach(cities, id: \.0) { city, timeZone in
//                ClockView(city: city, timeZone: timeZone, time: $time)
//                    .padding()
//            }
//
//            Spacer()
//        }
//        .onAppear {
//            ForEach(cities, id: \.0) { city in
//                updateClocks(for: city)
//            }
//        }
////        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
////            updateClocks()
////        }
//    }
//
//    private func updateClocks(for city: ClockView) {
//        fetchTime(for: city)
//    }
//
//    
//    func fetchTime(for city: ClockView) {
//            guard let url = URL(string: "http://worldtimeapi.org/api/timezone/\(city.city)") else {
//                return
//            }
//    
//    
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                guard let data = data, error == nil else {
//                    return
//                }
//    
//                do {
//                    let cityData = try JSONDecoder().decode(WorldTimeResponse.self, from: data)
//    
//                    DispatchQueue.main.async {
//                        city.time = cityData.datetime
//                    }
//                } catch {
//                    print("Error decoding JSON: \(error)")
//                }
//            }.resume()
//        }
//    }
//
//
//struct WorldTimeResponse: Decodable {
//    var datetime: String
//}
//
//struct ClockView: View {
//    let city: String
//    let timeZone: String
//    @Binding var time: String
//
//    var body: some View {
//        VStack {
//            Text(city)
//                .font(.headline)
//            Text("\(time)")
//                .font(.title)
//        }
//    }
//
//    private var timeFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.timeZone = TimeZone(identifier: timeZone)
//        formatter.timeStyle = .short
//        return formatter
//    }
//}
//
//
//struct WorldClockView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorldClockView()
//    }
//}
