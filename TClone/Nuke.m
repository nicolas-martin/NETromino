//
// Created by Nicolas Martin on 12/9/2013.
//


#import "Nuke.h"
#import "Field.h"
#import "Board.h"


@implementation Nuke {

}

- (Nuke *)initWith {
    self = [super init];
    if (self) {
        _spellName = @"nuke";
        _spriteFileName = @"nuke";

    }

    return self;
}

+ (Nuke *)init {
    return [[self alloc] initWith];
}

- (void)CastSpell:(Field *)targetField {
    Board *board = targetField.board;

    [board DeleteBlockFromBoardAndSprite:[board getAllBlocksInBoard]];

}

- (NSString *)LogSpell:(Field *)targetField {
    return [NSString stringWithFormat:@"%@ was casted on %@", _spellName, targetField.Name];
}
@end