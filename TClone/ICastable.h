//
// Created by Nicolas Martin on 11/30/2013.
//


#import <Foundation/Foundation.h>

@class Field;

@protocol ICastable

@property NSString *spellName;
@property NSString *spriteFileName;

- (void)CastSpell:(Field *)targetField;
- (NSString *)LogSpell:(Field *)targetField;

@end