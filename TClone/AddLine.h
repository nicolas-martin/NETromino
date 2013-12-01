//
// Created by Nicolas Martin on 11/30/2013.
//


#import <Foundation/Foundation.h>
#import "ICastable.h"

@class Field;

@interface AddLine : NSObject <ICastable>

@property (nonatomic, strong) NSString *spellName;
@property (nonatomic, strong) NSString *spriteFileName;

- (AddLine *)initWith;
+ (AddLine *)initStuff;
- (void)CastSpell:(Field *)targetField;
- (NSString *)LogSpell;

@end