//
//  BarcodeGeneratorView.swift
//  BarcodeGenerator
//
//  Created by Boyan Valkanov on 29.08.22.
//

import SwiftUI

enum BarcodeType: String, Equatable, CaseIterable{
    case QR      = "QR"
    case Aztec   = "Aztec"
    case Code128 = "Code128"
    case PDF417  = "PDF417"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

struct BarcodeGeneratorView: View {
    
    @State private var text = ""
    @Binding var codeType: BarcodeType
    
    var body: some View {
        VStack {
            TextField("Enter text...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .padding()
            
            if !text.isEmpty {
                Image(uiImage: UIImage(data: getBarcodeData(type: codeType, text: text)!)!)
                    .resizable()
                    .frame(width: 200, height: 200)
            }
        }
    }
    
    func getBarcodeData(type: BarcodeType, text: String) -> Data? {
        
        var ciFilterName: String
        
        switch type {
        case .QR:
            ciFilterName = "CIQRCodeGenerator"
        case .Aztec:
            ciFilterName = "CIAztecCodeGenerator"
        case .Code128:
            ciFilterName = "CICode128BarcodeGenerator"
        case .PDF417:
            ciFilterName = "CIPDF417BarcodeGenerator"
        }
        
        guard let filter = CIFilter(name: ciFilterName)
            else {
                return nil
        }
        let data = text.data(using: .ascii, allowLossyConversion: false)
        
        filter.setValue(data, forKey: "inputMessage")
        
        guard let ciimage = filter.outputImage
        else {
            return nil
        }
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        
        return uiimage.pngData()!
    }
}
