//
// Created by Nicolas Martin on 13-08-11.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "Board.h"
#import "Tetromino.h"


@interface Field : CCLayer {//<GameControllerObserver> {

}
@property (strong) CCTMXTiledMap *tileMap;
@property (strong) CCTMXLayer *layer;
@property (nonatomic, strong) Board *board;

- (id)initWithTileMap:(CCTMXTiledMap *)tileMap;

+ (id)layerWithTileMap:(CCTMXTiledMap *)tileMap;

- (void)checkForRowsToClear;

- (BOOL)canMoveTetrominoByXTetromino:(Tetromino *)userTetromino offSetX:(int)offSetX;

- (BOOL)isTetrominoInBounds:(Tetromino *)tetromino;

- (BOOL)boardRowEmpty:(int)x;
@end