//
//  ClearColumn.swift
//  TClone
//
//  Created by nma on 2014-06-15.
//
//

import Foundation

class ClearColumn : ICastable{
    var spellName : String = "Clear Column"
    var spriteFileName : String = "clearColumn.png"
    
    func CastSpell(targetField: Field) {
        let board = targetField.board
        let allBlockInTargetBoard = board.getAllBlocksInBoard()
        let nbBlocks = allBlockInTargetBoard.count
        
        let columnToClear = Int(arc4random_uniform(9))
        var blocksToClear = Block[]()
        
        for i in 0 .. nbBlocks{
            let block = allBlockInTargetBoard[i] as Block
            if block.boardY == columnToClear{
                blocksToClear.append(block)
            }
        }
        
        board.DeleteBlockFromBoardAndSprite(NSMutableArray(array: blocksToClear))
        
        
        LogSpell(targetField)
        
    }
    
    func LogSpell(targetField: Field) -> String {
        return "\(spellName) was casted on \(targetField.Name)"
    }
}