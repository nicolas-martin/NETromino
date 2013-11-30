//
// Created by Nicolas Martin on 11/30/2013.
//


#import <Foundation/Foundation.h>
#import "ICastable.h"

@class Field;

@interface AddLine : NSObject <ICastable>

@property(nonatomic, copy) NSString *spellName;

- (AddLine *)initWith;

+ (AddLine *)initStuff;


- (void)CastSpell:(Field *)targetField;

- (NSString *)LogSpell;

@end