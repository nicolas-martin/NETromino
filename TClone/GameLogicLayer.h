//
//  GameLogicLayer.h
//  Tetris
//
//  Created by Joshua Aburto on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "Tetromino.h"
#import "Block.h"
#import "Field.h"
#import "GameController.h"


#define kLastColumn 9
#define kLastRow 19

@interface GameLogicLayer : CCLayer <UIGestureRecognizerDelegate>
{



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
- (id)initWithFields:(Field *)mainFieldLayer and:(Field *)otherFieldLayer1 and:(Field *)otherFieldLayer2 and:(Field *)otherFieldLayer3 and:(Field *)otherFieldLayer4;

- (void)updateBoard:(ccTime)dt;

+(CCScene *) scene;

@property (nonatomic, strong) GameController *gameController;

@end
