//
// Created by Nicolas Martin on 11/30/2013.
//


#import <Foundation/Foundation.h>

@class Field;

@protocol ICastable

@property (nonatomic, strong) NSString *spellName;
@property (nonatomic, strong) Field *targetField;

-(void)CastSpell;
-(NSString *)LogSpell;

@end