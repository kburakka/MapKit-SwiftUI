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


    class Landmarks: ObservableObject {
        @Published var landMarks : [Landmark] = [
            .init(name: "Sydney Harbour Bridge", location: .init(latitude: -33.852222, longitude: 151.210556)),
            .init(name: "Brooklyn Bridge", location: .init(latitude: 40.706, longitude: -73.997)),
            .init(name: "Golden Gate Bridge", location: .init(latitude: 37.819722, longitude: -122.478611))
            ]
    }

    var landmarks = Landmarks()


struct ContentView: View {
    @State var counter: Int = 0
    @State var selectedLandmark: Landmark? = nil
    @State private var isShowingMarker = false
    @State private var convertedPoint: CGPoint? = nil
    @State var isList: Bool = false
    @State private var isShowingAlert = false
    @State private var alertInput = ""

    var body: some View {
        ZStack {
            MapView(landmarks: landmarks,
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
                    if !isShowingMarker{
                        Button(action: {
                            self.isShowingMarker = true
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
                            self.isShowingMarker = false
                            self.isShowingAlert = true
                        }) {
                            Text("DONE")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 3)
                                .padding(.bottom)
                        }
                    }
                    
                    Button(action: {
                        self.isList = true
                        
                    }) {
                        Text("LIST")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                            .padding(.bottom)
                    }.sheet(isPresented: $isList, content: {
                        ListView(landmarks: landmarks, selectedLandmark: self.$selectedLandmark)
                    })
                }
            }
            if isShowingMarker{
                Image("pin").resizable()
                .frame(width: 32.0, height: 32.0)
            }
        }.textFieldAlert(isShowing: $isShowingAlert, text: $alertInput, title: Text("Alert!"))
    }
    
    private func selectNextLandmark() {
        if let selectedLandmark = selectedLandmark, let currentIndex = landmarks.landMarks.firstIndex(where: { $0 == selectedLandmark }), currentIndex + 1 < landmarks.landMarks.endIndex {
            self.selectedLandmark = landmarks.landMarks[currentIndex + 1]
        } else {
            selectedLandmark = landmarks.landMarks.first
        }
    }
    private func selectPrevLandmark() {
        if let selectedLandmark = selectedLandmark, let currentIndex = landmarks.landMarks.firstIndex(where: { $0 == selectedLandmark }), currentIndex - 1 > -1 {
            self.selectedLandmark = landmarks.landMarks[currentIndex - 1]
        } else {
            selectedLandmark = landmarks.landMarks.last
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
extension View {
    func textFieldAlert(isShowing: Binding<Bool>,
                        text: Binding<String>,
                        title: Text) -> some View {
        TextFieldAlert(isShowing: isShowing,
                       text: text,
                       presenting: self,
                       title: title)
    }
}

struct TextFieldAlert<Presenting>: View where Presenting: View {
    @Binding var isShowing: Bool
    @Binding var text: String
    let presenting: Presenting
    let title: Text
    
    func convertPointToCoordinate(point : CGPoint) -> CLLocationCoordinate2D{
        return map.convert(point, toCoordinateFrom: map)
    }

    var body: some View {
        ZStack {
            presenting
                .disabled(isShowing)
            VStack {
                title
                TextField("Enter title", text: $text){
                    UIApplication.shared.endEditing()
                }
                Divider()
                HStack {
                    Button(action: {
                        withAnimation {
                            self.isShowing.toggle()
                        }
                        UIApplication.shared.endEditing()
                    }) {
                        Text("Dismiss")
                    }.padding()
                    Button(action: {
                        let coord = self.convertPointToCoordinate(point: map.center)
                        landmarks.landMarks.append(Landmark(name: self.text, location: coord))
                        UIApplication.shared.endEditing()
                        withAnimation {
                            self.isShowing.toggle()
                        }
                    }) {
                        Text("Save")
                    }.padding()
                }
            }
        .padding()
            .background(Color.white)
            .opacity(isShowing ? 1 : 0)
        }
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
