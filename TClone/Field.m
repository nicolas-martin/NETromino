//
// Created by Nicolas Martin on 13-08-11.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Field.h"


@implementation Field {

}
- (id)initWithTileMap:(CCTMXTiledMap *)tileMap {
    self = [super init];
    if (self) {
        self.tileMap = tileMap;
        [self addChild:tileMap];
    }

    return self;
}

+ (id)layerWithTileMap:(CCTMXTiledMap *)tileMap {
    return [[self alloc] initWithTileMap:tileMap];
}

@end