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

#define kLastColumn 9
#define kLastRow 19

@interface GameLogicLayer : CCLayer <UIGestureRecognizerDelegate>
{
	enum touchTypes {
		kNone,
		kDropBlocks,
		kMoveLeft,
		kMoveRight
	} touchType;
	
		
	Block *board[kLastColumn + 1][kLastRow + 1];
	
	//NSMutableArray *curRow;
	NSMutableArray *boardArray;	

	Tetromino *userTetromino;
	int frameCount;
	int moveCycleRatio;
	int difficulty;
	int score;
		
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

- (void)removeTetrominoFromBoard:(Tetromino *)tetrominoToDelete;

+(CCScene *) scene;

@end
