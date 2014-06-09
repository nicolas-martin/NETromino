//
// Created by Nicolas Martin on 13-08-15.
//
//
#import "CCScene.h"

@class Field;
@class GameController;
#define kLastColumn 9
#define kLastRow 19

@interface GameLogicLayer : CCLayer <UIGestureRecognizerDelegate>
{
    int playerWidth;
    int playerHeight;
    int playerTileSize;
    int nbPlayers;

    int mainWidth;
    int mainHeight;
    int mainTileSize;


	int frameCount;
	int moveCycleRatio;

	CGPoint dragStartPoint;
	CGPoint lastDragMove;
	int lastDragStartTime;
	
	NSMutableArray *tetrominoInGame;
    NSMutableArray *listOfControllers;

    Field * _MainField;
    Field * _FieldLayer1;
    Field * _FieldLayer2;
    Field * _FieldLayer3;
    Field * _FieldLayer4;


	
}

@property GameController *gameController;

- (void)AddBlocksToPlayer:(GameController *)controller blocksToAdd:(NSMutableArray *)blocks;

- (Field *)getFieldFromString:(NSString *)fieldName;

- (void)handleTap:(UITapGestureRecognizer *)sender;

+ (CCScene *) scene;



@end
