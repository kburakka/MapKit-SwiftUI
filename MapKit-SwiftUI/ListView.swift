//
//  ListView.swift
//  MapKit-SwiftUI
//
//  Created by burak kaya on 31/12/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import SwiftUI

struct ListView: View {
    @Binding var landmarks: [Landmark]

    var body: some View {
        NavigationView {
            List() {
                ForEach(landmarks.indices) { i in
                    Text("\(self.landmarks[i].name)")
                }
            }
            .navigationBarTitle("Menu")
        }
    }
}
