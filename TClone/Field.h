//
// Created by Nicolas Martin on 13-08-11.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <GameKit/GameKit.h>
#import "cocos2d.h"


@interface Field : CCLayer
@property (strong) CCTMXTiledMap *tileMap;

- (id)initWithTileMap:(CCTMXTiledMap *)tileMap;

+ (id)layerWithTileMap:(CCTMXTiledMap *)tileMap;


@end