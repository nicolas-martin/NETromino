//
// Created by Nicolas Martin on 13-08-15.
//
//
#import "Tetromino.h"
#import "Block.h"
#import "Field.h"
#import "GameController.h"


#define kLastColumn 9
#define kLastRow 19

@interface GameLogicLayer : CCLayer <UIGestureRecognizerDelegate>
{
    int playerWidth;
    int playerHeight;
    int playerTileSize;

    int mainWidth;
    int mainHeight;
    int mainTileSize;


	int frameCount;
	int moveCycleRatio;

	CGPoint dragStartPoint;
	CGPoint lastDragMove;
	int lastDragStartTime;
	
	NSMutableArray *tetrominoInGame;

    Field * _MainField;
    Field * _FieldLayer1;
    Field * _FieldLayer2;
    Field * _FieldLayer3;
    Field * _FieldLayer4;


	
}

@property (nonatomic, strong) GameController *gameController;

- (void)AddBlocksToPlayer:(GameController *)controller blocksToAdd:(NSMutableArray *)blocks;

- (id)initWithFields:(Field *)mainFieldLayer and:(Field *)otherFieldLayer1 and:(Field *)otherFieldLayer2 and:(Field *)otherFieldLayer3 and:(Field *)otherFieldLayer4;

+(CCScene *) scene;



@end
