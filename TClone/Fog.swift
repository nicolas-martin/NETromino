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
        
        
        //TODO: Add way to obstruct the field vision
        
        LogSpell(targetField)
        
    }
    
    func LogSpell(targetField: Field) -> String {
        return "\(spellName) was casted on \(targetField.Name)"
    }
}