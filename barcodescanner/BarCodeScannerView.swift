//
//  ContentView.swift
//  barcodescanner
//
//  Created by Agustin Carbajal on 16/11/2023.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title:String
    let message:String
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let invalidDeviceInput =  AlertItem(title: "Invalid", message: "Invalid device input", dismissButton: .default(Text("Ok")))
    static let invalidScannedInput =  AlertItem(title: "Invalid", message: "Invalid scanned input", dismissButton: .default(Text("Ok")))
}

struct BarCodeScannerView: View {
    
    @State private var scannedCode: String = ""
    @State private var alertItem: AlertItem?
    
    var body: some View {
        NavigationView {
            VStack {
                ScannerView(scannedCode: $scannedCode, alertItem: $alertItem)
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
            .alert(item: $alertItem) {
                alertItem in
                Alert(title: Text(alertItem.title),
                                      message: Text(alertItem.message),
                                      dismissButton: alertItem.dismissButton)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BarCodeScannerView()
    }
}
