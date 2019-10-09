//
//  ContentView.swift
//  MapKit-SwiftUI
//
//  Created by burak kaya on 09/10/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//
import SwiftUI
import CoreLocation
import MapKit

struct Landmark: Equatable {
    static func ==(lhs: Landmark, rhs: Landmark) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID().uuidString
    let name: String
    let location: CLLocationCoordinate2D
}

struct ContentView: View {
    @State var landmarks: [Landmark] = [
        Landmark(name: "Sydney Harbour Bridge", location: .init(latitude: -33.852222, longitude: 151.210556)),
        Landmark(name: "Brooklyn Bridge", location: .init(latitude: 40.706, longitude: -73.997)),
        Landmark(name: "Golden Gate Bridge", location: .init(latitude: 37.819722, longitude: -122.478611))
    ]
    @State var counter: Int = 0
    @State var selectedLandmark: Landmark? = nil
    @State private var showingAlert = false
    @State private var convertedPoint: CGPoint? = nil

    var body: some View {
        
        ZStack {
            MapView(landmarks: $landmarks,
                    selectedLandmark: $selectedLandmark, convertedPoint: $convertedPoint)
                .edgesIgnoringSafeArea(.vertical)
            VStack {
                Spacer()
                HStack{
                    Button(action: {
                        self.selectPrevLandmark()
                    }) {
                        Text("Prev")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                            .padding(.bottom)
                    }
                    Button(action: {
                        self.selectNextLandmark()
                    }) {
                        Text("Next")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                            .padding(.bottom)
                    }
                    if !showingAlert{
                        Button(action: {
                            self.showingAlert = true
                        }) {
                            Text("ADD")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                                .shadow(radius: 3)
                                .padding(.bottom)
                        }
                    }else{
                        Button(action: {
                            self.showingAlert = false
                        }) {
                            Text("DONE")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(8)
                                .shadow(radius: 3)
                                .padding(.bottom)
                        }
                    }
                }
            }
            if showingAlert{
                Image("pin").resizable()
                .frame(width: 32.0, height: 32.0)
            }
        }
    }
    
    private func selectNextLandmark() {
        if let selectedLandmark = selectedLandmark, let currentIndex = landmarks.firstIndex(where: { $0 == selectedLandmark }), currentIndex + 1 < landmarks.endIndex {
            self.selectedLandmark = landmarks[currentIndex + 1]
        } else {
            selectedLandmark = landmarks.first
        }
    }
    private func selectPrevLandmark() {
        if let selectedLandmark = selectedLandmark, let currentIndex = landmarks.firstIndex(where: { $0 == selectedLandmark }), currentIndex - 1 > -1 {
            self.selectedLandmark = landmarks[currentIndex - 1]
        } else {
            selectedLandmark = landmarks.last
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
