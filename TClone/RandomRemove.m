//
// Created by Nicolas Martin on 11/30/2013.
//


#import "RandomRemove.h"
#import "Field.h"


@implementation RandomRemove {

}
- (RandomRemove *)initWith {
    self = [super init];
    if (self) {
        _spellName = @"randomRemove";
        _spriteFileName = @"randomRemove.png";

    }

    return self;
}

+ (RandomRemove *)init {
    return [[self alloc] initWith];
}

- (void)CastSpell:(Field *)targetField {

}

- (NSString *)LogSpell:(Field *)targetField {
    return nil;
}

@end