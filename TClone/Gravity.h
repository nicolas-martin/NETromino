//
// Created by Nicolas Martin on 12/31/2013.
//


#import <Foundation/Foundation.h>
#import "ICastable.h"

@class Field;


@interface Gravity : NSObject <ICastable>

@property NSString *spellName;
@property NSString *spriteFileName;

- (Gravity *)initWith;
- (void)CastSpell:(Field *)targetField;
- (NSString *)LogSpell:(Field *)targetField;
+ (Gravity *)init;

@end