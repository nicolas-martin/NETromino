//
// Created by Nicolas Martin on 11/30/2013.
//


#import <Foundation/Foundation.h>
#import "ICastable.h"

@interface AddLine : NSObject <ICastable>

@property(nonatomic, strong) Field *targetField;

@property(nonatomic, copy) NSString *spellName;

- (AddLine *)initWith;

+ (AddLine *)initStuff;


- (void)CastSpell;

- (NSString *)LogSpell;

@end