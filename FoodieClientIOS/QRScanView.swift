//
//  QRScanView.swift
//  FoodieClientIOS
//
//  Created by Calogero Friscia on 07/12/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage
import CodeScanner

struct QRScanView:View {
    
    let backgroundColorView:Color
    
    @State private var keyAccess:String = "UserUID"
    @State private var isShowingScanner:Bool = false
    
    var body: some View {
        
        NavigationStack {
            CSZStackVB(title: "Scan Menu Qr", backgroundColorView: backgroundColorView) {
                
                VStack {
                    Text("FireStoreKeyAcceass:\(keyAccess)")
                    
                    Button {
                        self.isShowingScanner.toggle()
                    } label: {
                        Text("ScanQR")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(CatalogoColori.seaTurtle_3.color())
                    }
                }

            }
            .popover(isPresented: $isShowingScanner, content: {
                CodeScannerView(codeTypes: [.qr]) { result in
                    handleScan(result: result)
                    
                }.presentationDetents([.medium])

            })
        
        }
        
    }
    
    // Method
    
    func handleScan(result:Result<ScanResult,ScanError>) {
        
        // handle QRCode
        isShowingScanner = false
        
        switch result {
        case .success(let success):
            let details = success.string.components(separatedBy: "\n")
            self.keyAccess = success.string
            
            print("link:\(details) and type:\(success.type.rawValue)")
            guard details.count == 2 else { return }
            
     
            
        case .failure(let failure):
            print("Scan Failure :\(failure.localizedDescription)")
        }
        
    }
    
}

struct QRScanView_Previews: PreviewProvider {
    static var previews: some View {
        QRScanView(backgroundColorView: CatalogoColori.seaTurtle_1.color())
    }
}
