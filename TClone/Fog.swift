//
//  Fog.swift
//  TClone
//
//  Created by nma on 2014-06-15.
//
//

import Foundation

class Fog : ICastable{
    var spellName : String = "Fog"
    var spriteFileName : String = "fog"
    
    func CastSpell(targetField: Field) {
        
        let fogLayer = FogLayer()
                
        var gameLogicLayer = GameLogicLayer.sharedManager()
        var field = gameLogicLayer.getFieldFromString(targetField.Name) as Field

        fogLayer.position = CGPoint(x: field.contentSize.width/2, y: field.contentSize.height/2)
        
        gameLogicLayer.addChild(fogLayer)
        
        
        //TODO: find a way to figure out if the spell was dropped on "you"
        //maybe with global player identifier?
        
        LogSpell(targetField)
        
    }
    
    func LogSpell(targetField: Field) -> String {
        return "\(spellName) was casted on \(targetField.Name)"
    }
}