//
// Created by Nicolas Martin on 11/30/2013.
//


#import <Foundation/Foundation.h>
#import "ICastable.h"

@class Field;

@interface AddLine : NSObject <ICastable>

@property NSString *spellName;
@property NSString *spriteFileName;

- (AddLine *)initWith;
+ (AddLine *)init;
- (void)CastSpell:(Field *)targetField;
- (NSString *)LogSpell:(Field *)targetField;


@end