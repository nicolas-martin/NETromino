//
// Created by Nicolas Martin on 12/9/2013.
//


#import <Foundation/Foundation.h>
#import "ICastable.h"

@class Field;


@interface Nuke : NSObject <ICastable>

@property NSString *spellName;
@property NSString *spriteFileName;

+ (Nuke *)init;

- (NSString *)LogSpell:(Field *)targetField;
- (void)CastSpell:(Field *)targetField;
@end