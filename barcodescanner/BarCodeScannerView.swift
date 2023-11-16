//
//  ContentView.swift
//  barcodescanner
//
//  Created by Agustin Carbajal on 16/11/2023.
//

import SwiftUI

struct BarCodeScannerView: View {
    
    @State private var scannedCode: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ScannerView(scannedCode: $scannedCode)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                
                Spacer().frame(height: 60)
                
                Label("Scan barcode", systemImage: "barcode.viewfinder")
                    .font(.largeTitle)
                    .padding()
                
                Text(scannedCode.isEmpty ? "Not Yet Scanned" : scannedCode)
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(.green)
                    .padding()
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
