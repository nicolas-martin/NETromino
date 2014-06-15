//
//  Switch.swift
//  TClone
//
//  Created by nma on 2014-06-15.
//
//

import Foundation

class SwitchField : ICastable{
    var spellName : String = "Switch Field"
    var spriteFileName : String = "switchField.png"
    
    func CastSpell(targetField: Field) {
        let board = targetField.board
        let allBlockInTargetBoard = board.getAllBlocksInBoard()
        
        //TODO: Find a better way. Maybe with enums?
        var gameLogicLayer = GameLogicLayer.sharedManager()
        var field = gameLogicLayer.getFieldFromString("MainField") as Field
        var allBlockInOwnBoard = field.board.getAllBlocksInBoard()
        
        //TODO Switch-a-roo
        
        
        
        
        LogSpell(targetField)
        
    }
    
    func LogSpell(targetField: Field) -> String {
        return "\(spellName) was casted on \(targetField.Name)"
    }
}