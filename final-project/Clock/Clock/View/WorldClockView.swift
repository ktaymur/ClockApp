//
//  WorldClockView.swift
//  Clock
//
//  Created by Kate Murray on 4/17/24.
//

//import SwiftUI
//
//struct WorldClockView: View {
//    @State private var cities: [City] = [
//        City(name: "New York", timeZone: "America/New_York"),
//        City(name: "London", timeZone: "Europe/London"),
//        City(name: "Tokyo", timeZone: "Asia/Tokyo")
//        // Add more cities as needed
//    ]
//    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    @State var searchView = false
//
//    var body: some View {
//        VStack{
//            HStack{
//                Button(action: {}, label: {Text("Edit")})
//                    .foregroundStyle(.orange)
//                    .font(.title)
//                    .padding(.leading)
//                Spacer()
//                Button{searchView = true} label: {
//                    Image(systemName: "plus")
//                        .foregroundStyle(.orange)
//                        .font(.largeTitle)
//                    .padding(.trailing)}
//            }
//            VStack{
//                List(cities) { city in
//                    VStack(alignment: .leading) {
//                        Text(city.name)
//                        Text(city.currentTime)
//                            .font(.headline)
//                    }
//                    .onAppear(){
//                        fetchTime(for: city)
//                    }
//                }
//                
////                .onReceive(timer) { _ in
////                    fetchWorldTimes()
////                }
////                .onAppear {
////                    fetchWorldTimes()
////                }
//                
//            }
//        }
//        .sheet(isPresented: $searchView){
//            AddCityView()
//        }
//        
//        }
//    func addCity(for city: City){
//        
//    }
//    
//    func delete(at offsets: IndexSet) {
//            cities.remove(atOffsets: offsets)
//        }
//
////    func fetchWorldTimes() {
////        guard let url = URL(string: "http://worldtimeapi.org/api/timezone/") else {
////            return
////        }
////
////        URLSession.shared.dataTask(with: url) { data, response, error in
////            guard let data = data, error == nil else {
////                return
////            }
////
////            do {
////                let citiesData = try JSONDecoder().decode([String].self, from: data)
////
////                DispatchQueue.main.async {
////                   
////                    self.cities = citiesData.map { City(name: $0) }
////                }
////
////                for var city in self.cities {
////                    self.fetchTime(for: city)
////                }
////            } catch {
////                print("Error decoding JSON: \(error)")
////            }
////        }.resume()
////    }
//
//    func fetchTime(for city: City) {
//        guard let url = URL(string: "http://worldtimeapi.org/api/timezone/\(city.name)") else {
//            return
//        }
//
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                return
//            }
//
//            do {
//                let cityData = try JSONDecoder().decode(WorldTimeResponse.self, from: data)
//
//                DispatchQueue.main.async {
//                    city.currentTime = cityData.datetime
//                }
//            } catch {
//                print("Error decoding JSON: \(error)")
//            }
//        }.resume()
//    }
//}
//
//struct AddCityView: View {
//    @State private var city = ""
//    
//    var body: some View {
//        VStack{
//            Form{
//                TextField("Enter a City", text: $city)
//                    .onSubmit {
//                        
//                        
//                    }
//            }
//        }
//    }
//}
//
//struct City: Identifiable {
//    var id = UUID()
//    var name: String
//    var timeZone: String
//    @State var currentTime: String = ""
//}
//
//struct WorldTimeResponse: Decodable {
//    var datetime: String
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorldClockView()
//    }
//}
