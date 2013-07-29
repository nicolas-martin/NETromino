//
//  GameLogicLayer.m
//  Tetris
//
//  Created by Joshua Aburto on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameLogicLayer.h"
#import "GameOverLayer.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
@interface GameLogicLayer (private)

- (void)startGame;
- (void)createNewTetromino;
- (void)tryToCreateNewTetromino;

- (void)processTaps;

- (void)moveBlocksDown;
- (void)moveBlockDown:(Block *)block;

- (void)gameOver;
- (void)moveTetrominoDown;

- (BOOL)boardRowEmpty:(int)column;

- (void)moveTetrominoLeft;
- (void)moveTetrominoRight;

- (BOOL)canMoveTetrominoByX:(int)offSetX;

- (void)moveBlockX:(Block *)block byX:(int)offsetX;
@end

@implementation GameLogicLayer


+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    
    GameLogicLayer *layer = [GameLogicLayer node];
    
    [scene addChild: layer];

    return scene;
}



- (id)init
{
	if ((self = [super init])) {
		isTouchEnabled_ = YES;
		tetronimoInGame = [[NSMutableArray alloc] init];
		
		
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		//NSLog(@"=====================================");
		//NSLog(@"window height = %f", size.height);
		//NSLog(@"window width = %f", size.width);
		//NSLog(@"=====================================");
		CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"tetris_bg.jpg"];
			background.rotation = 90;
		} else {
			background = [CCSprite spriteWithFile:@"tetris_bg.jpg"];
		}
		background.position = ccp(size.width/2, size.height/2);
		
		// add the label as a child to this Layer
		[self addChild: background];
		
		
		[self startGame];
	}
	return self;
}

- (void)startGame
{
	//The board is one big block?
	memset(board, 0, sizeof(board));
	
	[self tryToCreateNewTetromino];
	frameCount = 0;
	moveCycleRatio = 40;
	[self schedule:@selector(updateBoard:) interval:(1.0/60.0)];
}

- (void)updateBoard:(ccTime)dt
{
	frameCount += 1;
	//[self processTaps];
	if (frameCount % moveCycleRatio == 0) {
		[self moveBlocksDown];
	}
}

//Creates a new block
- (void)createNewTetromino
{
	Tetromino *tempTetromino = [Tetromino randomBlockUsingBlockFrequency];
	
	//Tetromino *tempTetromino = [Tetromino blockWithType:0 orientation:0 BoardX:0 BoardY:0];
	
	
	for (Block *currentBlock in tempTetromino.children) {
		
		board[currentBlock.boardX][currentBlock.boardY] = currentBlock;
	}
	userTetromino = tempTetromino;
	[self addChild:userTetromino];
	[tetronimoInGame addObject:userTetromino];

	
	NSLog(@"+++++++ %d +++++++", tetronimoInGame.count);
	
	
}

- (void)tryToCreateNewTetromino
{
	//TODO: Implement a more robust logic
	// If any spot in the top two rows where blocks spawn is taken
	for (int i = 4; i < 8; i++)
	{
		for (int j = 0; j < 2; j++) {
			if (board[i][j]) {
				[self gameOver:NO];
			}
		}
	}
	[self createNewTetromino];
}


//TODO: Move this to Tetromino?
- (void)moveBlocksDown
{
	Block *currentBlock = nil;
	BOOL alreadyMovedTetromino = NO;
	// Get a new Tetromino if Tetromino cant move anymore
	if(userTetromino.stuck) {
		[self tryToCreateNewTetromino];
	}
	
	//???: This logic is fucked up
	// Go through board from bottom to top
	for (int x = kLastColumn; x >= 0 ; x--) {
		for (int y = kLastRow; y >= 0; y--) {
			currentBlock = board[x][y];
			if (currentBlock != nil) {
				
				if ([userTetromino isBlockInTetromino:currentBlock]) {
					if (!(alreadyMovedTetromino)) {
						[self moveTetrominoDown];
						alreadyMovedTetromino = YES;
					}
					
				} else if (y != kLastRow && ([self boardRowEmpty:x])){
					[self moveBlockDown:currentBlock];
					currentBlock.stuck = NO;
				}
				else {
					currentBlock.stuck = YES;
				}
			}
		}
	}
	
}

- (BOOL)boardRowEmpty:(int)column
{
	for (int i = 0;i < kLastRow; i++) {
		if (board[column][i]) {
			return NO;
		}
	}
	return YES;
}

- (void)moveTetrominoDown
{
	//for each block of the tetronimo
	for (Block *currentBlock in userTetromino.children) {
		//Gets next block
		Block *blockUnderCurrentBlock = board[currentBlock.boardX][currentBlock.boardY + 1];
		if (!([userTetromino isBlockInTetromino:blockUnderCurrentBlock])) {
			
			//If the block is at the bottom or there's a block under. It's stuck!
			if (currentBlock.boardY == kLastRow ||
				(board[currentBlock.boardX][currentBlock.boardY + 1] != nil)) {
				userTetromino.stuck = YES;
			}
		}
	}
	
	
/*
	NSString *blockPositions = [[NSString alloc] init];
	NSString *blockPositionInline = [[NSString alloc] init];
	for (Block *block in userTetromino.children) {
		
		blockPositions = [NSString stringWithFormat:@"[ %d, %d ]", block.boardX, block.boardY];
		
		blockPositionInline = [blockPositionInline stringByAppendingString:blockPositions];
		
	}
	NSLog(@"Block %@", blockPositionInline);*/
	
	
	//If the block is not stuck move it down
	if (!userTetromino.stuck) {
		// Reverse block enumerator so they dont overlap when you're shifting down
		CCArray *reversedBlockArray = [[CCArray alloc] initWithArray:userTetromino.children];  
		[reversedBlockArray reverseObjects]; // reverse contents
		for (Block* currentBlock in reversedBlockArray) {
			board[currentBlock.boardX][currentBlock.boardY] = nil;
			board[currentBlock.boardX][currentBlock.boardY + 1] = currentBlock;
		}
		
		//???: Redundant loops through all the blocks again?
		[userTetromino moveTetrominoDown];
		
	}
}


- (void)moveTetrominoLeft
{
	if ([self canMoveTetrominoByX:-1]) {
		
		CCArray *reversedBlockArray = [[CCArray alloc] initWithArray:userTetromino.children];  // make copy
		//[reversedBlockArray reverseObjects]; // reverse contents
		for (Block* currentBlock in reversedBlockArray) {
			[self moveBlockX:currentBlock byX:-1];
		}
		userTetromino.anchorX -= 1;
	}
}


- (void)moveTetrominoRight
{
	if ([self canMoveTetrominoByX:1]) {
		
		CCArray *reversedBlockArray = [[CCArray alloc] initWithArray:userTetromino.children];  // make copy
		[reversedBlockArray reverseObjects]; // reverse contents
		for (Block* currentBlock in reversedBlockArray) {
			[self moveBlockX:currentBlock byX:1];
		}
		
		userTetromino.anchorX += 1;
	}
	
}

- (BOOL)canMoveTetrominoByX:(int)offSetX
{
	// Sort blocks by x value if moving left, reverse order if moving right
	CCArray *reversedChildren = [[CCArray alloc] initWithArray:userTetromino.children];  // make copy
	
	if (offSetX > 0) {
		[reversedChildren reverseObjects]; // reverse contents
	}
	
	for (Block *currentBlock in reversedChildren) {
		Block *blockNextToCurrentBlock = board[currentBlock.boardX + offSetX][currentBlock.boardY];
		//dont compare yourself
		if (!([userTetromino isBlockInTetromino:blockNextToCurrentBlock])) {
			//if there's another block at the position you're looking at, you can't move
			if (board[currentBlock.boardX + offSetX][currentBlock.boardY] != nil) {
				return NO;
			}
		}
	}
	return YES;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView: [touch view]];
	
	CGFloat leftMostX = 0;
	CGFloat rightMostX = 0;
	CGFloat lowestY = 0;
	CGFloat highestY = 0;

	leftMostX = COMPUTE_X([userTetromino leftMostPosition].x);
	rightMostX = COMPUTE_X([userTetromino rightMostPosition].x);	
	lowestY = COMPUTE_Y([userTetromino lowestPosition].y);
	highestY = COMPUTE_Y([userTetromino highestPosition].y);
	
	location = [[CCDirector sharedDirector] convertToGL:location];
	
	//Drop only if touched right under the piece
	if (location.y < lowestY)
	{
		//touchType = kDropBlocks;
		touchType = kBlockFlip;
	}
	
	else if (location.x < leftMostX)
	{
		touchType = kMoveLeft;
	}
	else if (location.x > rightMostX)
	{
		touchType = kMoveRight;
	}/*
	else if (location.y > highestY)
	{
		touchType = kBlockFlip;
	}*/
	[self processTaps];
	
	
}

- (void)rotateTetromino:(RotationDirection)direction
{
    Tetromino *rotated = [Tetromino blockWithType:userTetromino.type Direction:direction BoardX:userTetromino.anchorX BoardY:userTetromino.anchorY CurrentOrientation:userTetromino.orientation];
    
	for (Block *currentBlock in rotated.children)
	{
		//check if the new block is within the bounds and
		if(currentBlock.boardX < 0 || currentBlock.boardX > kLastColumn || currentBlock.boardY < 0 || currentBlock.boardY > kLastRow || (board[currentBlock.boardX][currentBlock.boardY] == nil))
		{
			NSLog(@"DENIED");
			return;
			
		}
	}
	
	
	//Delete old tetromino
	for (Block *currentBlock in userTetromino.children)
	{
		board[currentBlock.boardX][currentBlock.boardY] = nil;
		
	}
	[self removeChild:userTetromino cleanup:YES];
	
	//add rotated to board
	for (Block *currentBlock in rotated.children)
	{
		board[currentBlock.boardX][currentBlock.boardY] = currentBlock;
	}
	userTetromino = rotated;
	[self addChild:userTetromino];
}



- (void)processTaps
{
	if (touchType == kDropBlocks)
	{
		touchType = kNone;
		
		while (!userTetromino.stuck)
		{
			[self moveTetrominoDown];
		}
	}
	else if (touchType == kMoveLeft)
	{
		touchType = kNone;
		
		if (userTetromino.leftMostPosition.x > 0 && !userTetromino.stuck)
		{
			[self moveTetrominoLeft];
		}
	}
	else if (touchType == kMoveRight)
	{
		touchType = kNone;
		
		if (userTetromino.rightMostPosition.x < kLastColumn && !userTetromino.stuck)
		{
			[self moveTetrominoRight];
		}
	}
	else if (touchType == kBlockFlip)
	{
		touchType = kNone;
		

		[self rotateTetromino:rotateClockwise];
		
	}
	
}


- (void)moveBlockDown:(Block *)block
{
	board[block.boardX][block.boardY] = nil;
	board[block.boardX][block.boardY + 1] = block;
}


//Helper function to recalculate left and right block positions
- (void)moveBlockX:(Block *)block byX:(int)offsetX
{
	//double checking to see if there's nothing
	if (board[block.boardX + offsetX][block.boardY] == nil) {
		board[block.boardX][block.boardY] = nil;
		board[block.boardX + offsetX][block.boardY] = block;
		
		[block moveByX:offsetX];
	}
}


- (void)gameOver:(BOOL)won
{
	CCScene *gameOverScene = [GameOverLayer sceneWithWon:won];
	[[CCDirector sharedDirector] replaceScene:gameOverScene];
	
}
@end
