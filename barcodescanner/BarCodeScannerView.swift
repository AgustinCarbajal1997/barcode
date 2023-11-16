//
//  ContentView.swift
//  barcodescanner
//
//  Created by Agustin Carbajal on 16/11/2023.
//

import SwiftUI

struct BarCodeScannerView: View {
    var body: some View {
        NavigationView {
            VStack {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 300)
                
                Label("Scan barcode", systemImage: "barcode.viewfinder")
                    .font(.title)
                    .padding()
                
                Text("Not yet scanned")
            }
            .navigationTitle("Barcode scanner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BarCodeScannerView()
    }
}
