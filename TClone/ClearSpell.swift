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
        let nbBlocks = allBlockInBoard.count
        
        //TODO: Work around because "for block in allBlocksInBoard"
        //crashes xcode6 in beta
        
        for i in 0 .. nbBlocks{
            let block = allBlockInBoard[i] as Block
            if block.spell{
                block.removeSpell()
            }
        }
        
         LogSpell(targetField)
        
    }
    
    func LogSpell(targetField: Field) -> String {
        return "\(spellName) was casted on \(targetField.Name)"
    }
    
}
