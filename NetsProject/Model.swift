//
//  Model.swift
//  NetsProject
//
//  Created by Hayden Ang on 26/9/22.
//

import UIKit
import RealityKit
import Combine

class Model {
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?

    private var cancellable: AnyCancellable? = nil

    init(modelName: String){
        self.modelName = modelName

        self.image =  UIImage(named: modelName)!

        let fileName =  modelName + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: fileName)
            .sink(receiveCompletion: {
                loadCompletion in
                //Handle our Error
                print("Unable to load modelEntity for modelName: \(self.modelName)")
            }, receiveValue:  { modelEntity in
                //Get Our ModelEntity
                self.modelEntity =  modelEntity
                print("Sucessfully loaded ModelEntity for modelName: \(self.modelName)")
            })
    }
}
