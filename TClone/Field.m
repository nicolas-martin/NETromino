//
// Created by Nicolas Martin on 13-08-11.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Field.h"
#import "Board.h"


@implementation Field {

}
- (id)initWithTileMap:(CCTMXTiledMap *)tileMap {
    self = [super init];
    if (self) {
        self.tileMap = tileMap;
        [self addChild:tileMap];
        [_board init];
        self.layer = [tileMap layerNamed:@"Tile Layer 1"];
    }

    return self;
}

+ (id)layerWithTileMap:(CCTMXTiledMap *)tileMap {
    return [[self alloc] initWithTileMap:tileMap];
}



- (void)checkForRowsToClear {

    [_board clearFullRows];

}

- (void)updateTetrominoPosition:(Tetromino *)tetromino {

}


- (BOOL)boardRowEmpty:(int)y {

    return [_board boardRowEmpty:y];

}
@end