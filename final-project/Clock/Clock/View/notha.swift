//
//  notha.swift
//  Clock
//
//  Created by Kate Murray on 4/22/24.
//

import SwiftUI

struct WorldClockView: View {
    @State private var cities: [City] = [
        City(name: "New York", timeZone: "America/New_York"),
        City(name: "London", timeZone: "Europe/London"),
        City(name: "Tokyo", timeZone: "Asia/Tokyo")
        // Add more cities as needed
    ]
    @State private var searchText = ""
    @State private var isAddingCity = false
    
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $searchText)
                    .padding(.horizontal)
                Button("Add") {
                    isAddingCity = true
                }
                .padding(.trailing)
            }
            List(cities.filter { $0.name.lowercased().contains(searchText.lowercased()) }) { city in
                VStack(alignment: .leading) {
                    Text(city.name)
                    Text(city.currentTime)
                        .font(.headline)
                }
                .onAppear {
                    fetchTime(for: city)
                }
            }
        }
        .padding()
        .sheet(isPresented: $isAddingCity) {
            AddCityView(addCity: addCity)
        }
    }
        
        func fetchTime(for city: City) {
            guard let url = URL(string: "http://worldtimeapi.org/api/timezone/\(city.timeZone)") else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let cityData = try JSONDecoder().decode(WorldTimeResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        if let index = cities.firstIndex(where: { $0.id == city.id }) {
                            cities[index].currentTime = cityData.datetime
                        }
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        }
        
        func addCity(city: City) {
            cities.append(city)
            isAddingCity = false
        }
    
}

struct City: Identifiable {
    let id = UUID()
    let name: String
    let timeZone: String
    var currentTime: String = ""
}

struct WorldTimeResponse: Decodable {
    var datetime: String
}

struct AddCityView: View {
    @State private var cityName = ""
    @State private var timeZone = ""

    let addCity: (City) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("City Details")) {
                    TextField("City Name", text: $cityName)
                    TextField("Time Zone", text: $timeZone)
                }

                Section {
                    Button("Add City") {
                        let city = City(name: cityName, timeZone: timeZone)
                        addCity(city)
                    }
                    .disabled(cityName.isEmpty || timeZone.isEmpty)
                }
            }
            .navigationTitle("Add City")
        }
    }
}

#Preview {
    WorldClockView()
}
