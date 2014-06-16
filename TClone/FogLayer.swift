//
//  FogLayer.swift
//  TClone
//
//  Created by nma on 2014-06-16.
//
//

import Foundation

class FogLayer : CCLayer{
    
//    class func scene() -> CCScene{
//        
//        let scene = CCScene()
//     
//
//        let fogLayer = FogLayer()
//        fogLayer.addChild(background)
//
//       
//        scene.addChild(fogLayer)
//        
//        return scene
//        
//    }
    
    init(){
        super.init()
        
        //TODO: Make layer with transparent spots.
        
        let background = CCSprite(file: "fog.png")
        background.anchorPoint = CGPoint(x: 0, y: 0)
        
        let fogLayer = FogLayer()
        fogLayer.addChild(background)
        
    }
    
    
}