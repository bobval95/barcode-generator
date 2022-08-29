//
//  ContentView.swift
//  BarcodeGenerator
//
//  Created by Boyan Valkanov on 23.08.22.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedType: BarcodeType = BarcodeType.QR
    
    var body: some View {
        VStack(spacing: 5){
            HStack {
                Text("Barcode Generator")
                    .font(.system(.title))
                    .padding()
                Spacer()
            }
            Picker("Barcode type", selection: $selectedType){
                ForEach(BarcodeType.allCases, id: \.self ) { value in
                    Text(value.localizedName)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            BarcodeGeneratorView(codeType: $selectedType)
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
