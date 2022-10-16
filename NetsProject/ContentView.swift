//
//  ContentView.swift
//  NetsProject
//
//  Created by Hayden Ang on 26/9/22.
//

import SwiftUI
import RealityKit
import ARKit
struct ContentView : View {
    
    //Track State of Application:
    @State private var isPlacementEnabled =  false
    @State private var selectedModel: String?
    @State private var modelConfirmedForPlacement: String?
    
    var mdels: [String]? {
        let fileManager = FileManager.default
        let currentPath = fileManager.currentDirectoryPath
        print("Current path: \(currentPath)")
        return []
    }
    

    //List of Names of our Models
    var models: [String] = ["pyramid","testcube","cuboid"]
//    var models: [Model] = InitialiseListOfModels(listOfNames: modelsStringName)
    var body: some View{
        ZStack(alignment:  .bottom) {
            //Camera for AR View
            ARViewContainer(modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
            if (isPlacementEnabled){
                //UI for Placement for Models
                PlacementPickerView(isPlacementEnabled: self.$isPlacementEnabled,selectedModel: self.$selectedModel,modelConfirmedForPlacement: self.$modelConfirmedForPlacement )
            } else{
                //UI View for ModelsPicker
                ModelPickerView(models: self.models,isPlacementEnabled: self.$isPlacementEnabled, selectedModel: self.$selectedModel)
            }
            
        }
    }
    
//    func InitialiseListOfModels(listOfNames:[String]) -> [Model]{
//        var listOfModels: [Model]
//        for name in listOfNames {
//            let newModel = Model(modelName: name)
//            listOfModels.append(newModel)
//        }
//        return listOfModels
//    }
//    func loadModelsFromModels() -> [String]? {
//        let fileManager = FileManager.default
//        let currentPath = fileManager.currentDirectoryPath
//        print("Current path: \(currentPath)")
//        return []
//    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelConfirmedForPlacement: String?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal,.vertical]
        config.environmentTexturing =  .automatic

//        Checks whether device supports scene reconstruction(helps improve AR performance, if device doesnt have, APP will crash)
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
            config.sceneReconstruction = .mesh
        }

        arView.session.run(config)
        
        return arView
        
    }
    
    func updateUIVew(_ uiView: ARView, context: Context) {
        //If let to safely unwrap modelConfirmedForPlacement Optional
        if let modelName =  self.modelConfirmedForPlacement{
            print("WANTING TO UPDATE ARView")
            print("Adding \(modelName) to scene")
            let fileName: String
            //Placing Model into an Anchor
            fileName = modelName + ".usdz"
            let modelEntity = try! ModelEntity.load(named: fileName)
            let anchorEntity = AnchorEntity(plane: .any)
            anchorEntity.addChild(modelEntity)

            

            //Ensure only one Entity is in the scene
            let currentAnchors = uiView.scene.anchors
            if (currentAnchors.isEmpty){
                uiView.scene.addAnchor(anchorEntity)
            }
            else{
                uiView.scene.removeAnchor(currentAnchors.first!)
                uiView.scene.addAnchor(anchorEntity)
            }
            
            if (!modelEntity.availableAnimations.isEmpty){
                print("This is the list of Animations")
                print(modelEntity.availableAnimations)
                let modelAnimation = modelEntity.availableAnimations[0]
                modelEntity.playAnimation(modelAnimation.repeat(duration: .infinity))
            }
            
            DispatchQueue.main.async {
                self.modelConfirmedForPlacement = nil
            }
        }
    }

}

struct ModelPickerView: View {
    var models: [String]
    
    
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: String?

    
    var body: some View{
        ScrollView(.horizontal,showsIndicators: false){
            HStack(spacing: 30){
                ForEach(0..<self.models.count) {
                    index in
                    Button(action: {
                        print("Selected Model with name: \(self.models[index])")
                        self.isPlacementEnabled = true
                        self.selectedModel = self.models[index]
                    }, label: {
                        Image(uiImage: UIImage(named: self.models[index])!)
                            .resizable()
                            .frame(height:80)
                            .aspectRatio(1/1,contentMode: .fit)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }).buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.5))
    }
}

struct PlacementPickerView: View {
    
    //Binding Variable, gives read/write access to PlacementPickerView for variables outside of it's scope
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: String?
    @Binding var modelConfirmedForPlacement: String?
    
    var body: some View{
        HStack{
            //Cancel Button
            Button(action: {
                print("Cancel Placement!")
                self.cancelPlacementParams()
            }, label: {
                Image(systemName: "xmark")
                    .frame(width: 60, height: 60, alignment: .center)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            })
            
            Button(action: {
                print("Confirm Placement!")
                self.confirmPlacementParams()
            }, label: {
                Image(systemName: "checkmark")
                    .frame(width: 60, height: 60, alignment: .center)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            })
        }
    }
    
    func confirmPlacementParams(){
        self.modelConfirmedForPlacement = self.selectedModel
        self.resetPlacementParams()
    }
    
    func cancelPlacementParams(){
        self.resetPlacementParams()
    }
    
    func resetPlacementParams(){
        self.isPlacementEnabled = false
        self.selectedModel = nil
    }
}



#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
