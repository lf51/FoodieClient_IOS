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
    
    @EnvironmentObject var viewModel:ClientVM
    
    let backgroundColorView:Color
    @State private var isShowingScanner:Bool = true
    
    var body: some View {
        
        NavigationStack {
            CSZStackVB(title: "Menu", backgroundColorView: backgroundColorView) {
                
                VStack {
                  
              
                    
                    
                   /* Button {
                        self.isShowingScanner.toggle()
                    } label: {
                        Text("ScanQR")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(CatalogoColori.seaTurtle_3.color())
                    } */
                }

            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) { vbScanReload() }
                
            }
            .popover(isPresented: $isShowingScanner, content: {
                CodeScannerView(codeTypes: [.qr]) { result in
                    handleScan(result: result)
                    
                }.presentationDetents([.height(600)])

            })
        
        }
        
    }
    
    // Method
    
    @ViewBuilder func vbScanReload() -> some View {
        
        let cloudDataCreated:Bool = {
           
            self.viewModel.cloudDataCompiler != nil &&
            self.viewModel.cloudData != nil
            
        }()
            
        let frontColor = CatalogoColori.seaTurtle_1.color()
        let backColor = CatalogoColori.seaTurtle_3.color()
        
        CSButton_image(
            activationBool: cloudDataCreated,
            frontImage: "arrow.triangle.2.circlepath",
            backImage: "camera.fill",
            imageScale: .large,
            backColor: backColor,
            frontColor: frontColor) {
                
                scanReloadAction(dataIn: cloudDataCreated)

            }.disabled(self.isShowingScanner)
        
    }
    
    func scanReloadAction(dataIn:Bool) {
        
        if dataIn {
            
            self.viewModel.compilaCloudDataFromFirebase()
            
        } else {
            
            self.isShowingScanner.toggle()
            
        }
        
    }
    
    func handleScan(result:Result<ScanResult,ScanError>) {
        
        // handle QRCode
        isShowingScanner = false
        
        switch result {
        case .success(let success):

            self.viewModel.cloudDataCompiler = CloudDataCompiler(userUID: success.string)
            
            self.viewModel.compilaCloudDataFromFirebase()
            
            print("link:\(success.string) and type:\(success.type.rawValue)")
      
            
        case .failure(let failure):
            print("Scan Failure :\(failure.localizedDescription)")
        }
        
    }
    
}

struct QRScanView_Previews: PreviewProvider {
    static var previews: some View {
        QRScanView(backgroundColorView: CatalogoColori.seaTurtle_1.color())
            .environmentObject(ClientVM())
    }
}
