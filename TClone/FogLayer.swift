//
//  FogLayer.swift
//  TClone
//
//  Created by nma on 2014-06-16.
//
//

import Foundation

class FogLayer : CCLayer{
    
    class func scene() -> CCScene{
        
        let scene = CCScene()
        let fogLayer = FogLayer()
       
        scene.addChild(fogLayer)
        
        return scene
        
    }
    
    init(){
        super.init()
        
        
    }
    
    
}