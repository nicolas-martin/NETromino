//
//  ClearLine.swift
//  TClone
//
//  Created by nma on 2014-06-14.
//
//

import Foundation

class ClearLine : ICastable{
    var spellName : String = "Clear Line"
    var spriteFileName : String = "clearLine.png"
    
    func CastSpell(targetField: Field) {
        let board = targetField.board
        let allBlockInBoard = board.getAllBlocksInBoard()
        
        //TODO: Use global constant
        board.DeleteRow(19)
        targetField.setPositionUsingFieldValue(board.MoveBoardDown(18))
        
//        NSMutableArray *spellsToAdd = [_field.board DeleteRow:(NSUInteger)deletedRow];
//        if(spellsToAdd.count > 0)
//        {
//            [self addSpellsToInventory:spellsToAdd];
//        }
//        
//        [_field setPositionUsingFieldValue:[_field.board MoveBoardDown:(NSUInteger) (deletedRow - 1)]];
        
        LogSpell(targetField)
        
    }
    
    func LogSpell(targetField: Field) -> String {
        return "\(spellName) was casted on \(targetField.Name)"
    }
    
}