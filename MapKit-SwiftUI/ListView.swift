//
//  ListView.swift
//  MapKit-SwiftUI
//
//  Created by burak kaya on 31/12/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var landmarks = Landmarks()
    @State var isContent: Bool = false
    @State private var convertedPoint: CGPoint? = nil
    @Binding var selectedLandmark: Landmark?

    var body: some View {
        NavigationView {
            List() {
                ForEach(landmarks.landMarks.indices) { i in
                    Text("\(self.landmarks.landMarks[i].name)").onTapGesture {
                        self.isContent = true
                        self.selectedLandmark = self.landmarks.landMarks[i]
                    }.sheet(isPresented: self.$isContent, content: {
                        ContentView(counter: 0, selectedLandmark: self.selectedLandmark, isList: false)
//                        ContentView(landmarks: self.landmarks, counter: 0, selectedLandmark: self.selectedLandmark, isList: false)
                    })
                }
            }
            .navigationBarTitle("List")
        }
    }
}
