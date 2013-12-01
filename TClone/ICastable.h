//
// Created by Nicolas Martin on 11/30/2013.
//


#import <Foundation/Foundation.h>

@class Field;

@protocol ICastable

@property (nonatomic, strong) NSString *spellName;
@property (nonatomic, strong) NSString *spriteFileName;

- (void)CastSpell:(Field *)targetField;
-(NSString *)LogSpell;

@end