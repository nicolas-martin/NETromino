//
//  ClearSpell.swift
//  TClone
//
//  Created by nma on 2014-06-14.
//
//


class ClearSpell : ICastable{
    
    var spellName : String = "Clear Spell"
    var spriteFileName : String = "clearSpell.png"
    
    func CastSpell(targetField: Field) {
        let board = targetField.board
        let allBlockInBoard = board.getAllBlocksInBoard()
        
        for block in allBlockInBoard{

        }
        
        

        
        
    }
    
    func LogSpell(targetField: Field) -> String {
        return "\(spellName) was casted on \(targetField.Name)"
    }
    
}
