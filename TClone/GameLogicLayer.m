//
//  GameLogicLayer.m
//  Tetris
//
//  Created by Joshua Aburto on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameLogicLayer.h"
#import "GameOverLayer.h"
#import "CCNode+SFGestureRecognizers.h"
#import "Field.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
@interface GameLogicLayer (private)

- (void)startGame;
- (void)createNewTetromino;
- (void)tryToCreateNewTetromino;
- (void)processTaps;
- (void)moveBlocksDown;

- (void)moveTetrominoDown;
- (BOOL)boardRowEmpty:(int)column;
- (void)moveTetrominoLeft;
- (void)moveTetrominoRight;
- (BOOL)canMoveTetrominoByX:(int)offSetX;
- (void)moveBlockInBoardX:(Block *)block byX:(int)offsetX;

@end

@implementation GameLogicLayer


+(CCScene *) scene
{
    CCScene *scene = [CCScene node];

    Field *main = [Field node];
    [scene addChild:main z:1];

    Field *field1 = [Field node];
    [scene addChild:field1 z:1];

    Field *field2 = [Field node];
    [scene addChild:field2 z:1];

    Field *field3 = [Field node];
    [scene addChild:field3 z:1];

    Field *field4 = [Field node];
    [scene addChild:field4 z:1];


    GameLogicLayer *layer = [[GameLogicLayer alloc] initWithFields:main and:field1 and:field2 and:field3 and:field4];
    [scene addChild: layer];
    
    return scene;
}

- (id)initWithFields:(Field *)mainFieldLayer and:(Field *)otherFieldLayer1 and:(Field *)otherFieldLayer2 and:(Field *)otherFieldLayer3 and:(Field *)otherFieldLayer4 {

	if ((self = [super init]))
	{


        _MainField = mainFieldLayer;
        _FieldLayer1 = otherFieldLayer1;
        _FieldLayer2 = otherFieldLayer2;
        _FieldLayer3 = otherFieldLayer3;
        _FieldLayer4 = otherFieldLayer4;

        [_MainField initWithTileMap:[CCTMXTiledMap tiledMapWithTMXFile:@"32.tmx"]];
        [_FieldLayer1 initWithTileMap:[CCTMXTiledMap tiledMapWithTMXFile:@"16.tmx"]];
        [_FieldLayer2 initWithTileMap:[CCTMXTiledMap tiledMapWithTMXFile:@"16.tmx"]];
        [_FieldLayer3 initWithTileMap:[CCTMXTiledMap tiledMapWithTMXFile:@"16.tmx"]];
        [_FieldLayer4 initWithTileMap:[CCTMXTiledMap tiledMapWithTMXFile:@"16.tmx"]];


        CGSize winSize = [CCDirector sharedDirector].winSize;


        [_MainField setPosition:ccp(0,0)];
        [_FieldLayer1 setPosition:ccp(winSize.width - _FieldLayer1.tileMap.contentSize.width, 0)];
        [_FieldLayer2 setPosition:ccp(winSize.width - _FieldLayer2.tileMap.contentSize.width,
        winSize.height - _FieldLayer2.tileMap.contentSize.height)];
        [_FieldLayer3 setPosition:ccp(winSize.width - (_FieldLayer3.tileMap.contentSize.width + 200), 0)];
        [_FieldLayer4 setPosition:ccp(winSize.width - (_FieldLayer4.tileMap.contentSize.width + 200),
        winSize.height - (_FieldLayer4.tileMap.contentSize.height))];



        self.isTouchEnabled = YES;
		tetrominoInGame = [[NSMutableArray alloc] init];

		boardArray = [[NSMutableArray alloc] init];

		
		//creates gesture recognizer for the layer
		UISwipeGestureRecognizer *swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightGestureRecognizer:)];
		swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
		swipeRightGestureRecognizer.delegate = self;
		[self addGestureRecognizer:swipeRightGestureRecognizer];
		
		UISwipeGestureRecognizer *swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftGestureRecognizer:)];
		swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
		swipeLeftGestureRecognizer.delegate = self;
		[self addGestureRecognizer:swipeLeftGestureRecognizer];
		

		//[self startGame];
	
	}
	return self;
}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
    int x = position.x / _MainField.tileMap.tileSize.width;
    int y = ((_MainField.tileMap.mapSize.height * _MainField.tileMap.tileSize.height) - position.y) / _MainField.tileMap.tileSize.height;
    return ccp(x, y);
}

- (void)swipeRightGestureRecognizer:(UISwipeGestureRecognizer*)aGestureRecognizer
{
	[self rotateTetromino:rotateClockwise];
	
}

- (void)swipeLeftGestureRecognizer:(UISwipeGestureRecognizer*)aGestureRecognizer
{
	[self rotateTetromino:rotateCounterclockwise];
	
}

- (void)startGame
{
	memset(board, 0, sizeof(board));	
	[self tryToCreateNewTetromino];
	frameCount = 0;

	//TODO: Implement level speed here
	moveCycleRatio = 40;
	[self schedule:@selector(updateBoard:) interval:(1.0/60.0)];
}

- (void)updateBoard:(ccTime)dt
{
	frameCount += 1;
	if (frameCount % moveCycleRatio == 0)
	{

		[self moveBlocksDown];

	}
}

- (void)checkForLinesToClear
{
	Block *currentBlock = nil;
	BOOL occupied = NO;
	// Go through board from bottom to top	
	for (int y = kLastRow; y >= 0; y--)
	{
		occupied = NO;
		
		for (int x = kLastColumn; x >= 0 ; x--)
		{			
			currentBlock = board[x][y];
			if (currentBlock == nil)
			{
				occupied = NO;
				//Since there's an empty block on this column there's no need to look at the others
				//Exits both loops and get the next row
				break;
			}
			else
			{
				occupied = YES;

			}
		}
		
		if(occupied)
		{
			
			//Remove the row from the board
			for (int x = kLastColumn; x >= 0 ; x--)
			{
				Block *currentBlockToDelete = board[x][y];
				//[self removeChild:currentBlock cleanup:YES];
				
				board[x][y] = nil;
				
				[currentBlockToDelete MoveTo:board[x][y]];
				NSLog(@"- REMOVED A BLOCK AT X = %d AND Y = %d", x, y);
			}
			
			//Move down all the blocks above
			for (int currenty = y - 1; currenty >= 0; currenty--)
			{
				for (int x = kLastColumn; x >= 0 ; x--)
				{
					currentBlock = board[x][currenty];
					[currentBlock moveDown];
					board[x][currenty + 1] = currentBlock;
				}
			}
									
		}
		else
		{
			continue;
		}

	}
}


//Creates a new block
- (void)createNewTetromino
{
	Tetromino *tempTetromino = [Tetromino randomBlockUsingBlockFrequency];
	
	//Tetromino *tempTetromino = [Tetromino blockWithType:1 Direction:rotateNone BoardX:0 BoardY:0 CurrentOrientation:0];
		
	for (Block *currentBlock in tempTetromino.children)
	{
		
		board[currentBlock.boardX][currentBlock.boardY] = currentBlock;
	}
	
	userTetromino = tempTetromino;

    [_MainField addChild:userTetromino];
    //[self addChild:userTetromino];

	
	
}


- (void)tryToCreateNewTetromino
{
	// If any spot in the top two rows where blocks spawn is taken
	for (int i = 4; i < 8; i++)
	{
		for (int j = 0; j < 2; j++)
		{	
			if (board[i][j])
			{
				[self gameOver:NO];
			}
		}
	}
	[self createNewTetromino];
}

- (void)moveBlocksDown
{
	Block *currentBlock = nil;
	BOOL alreadyMovedTetromino = NO;

	if(userTetromino.stuck)
	{
		[self tryToCreateNewTetromino];
	}
	
	//???: This logic is fucked up
	// Go through board from bottom to top
	for (int x = kLastColumn; x >= 0 ; x--)
	{
		for (int y = kLastRow; y >= 0; y--)
		{
			currentBlock = board[x][y];
			if (currentBlock != nil)
			{				
				if ([userTetromino isBlockInTetromino:currentBlock])
				{
					if (!(alreadyMovedTetromino))
					{
						[self moveTetrominoDown];
						alreadyMovedTetromino = YES;
					}
					
				}
				else if (y != kLastRow && ([self boardRowEmpty:x]))
				{
					[currentBlock moveDown];
					currentBlock.stuck = NO;
				}
				else
				{
					currentBlock.stuck = YES;
					[self checkForLinesToClear];
					
				}
			}
		}
	}
	
}

- (BOOL)boardRowEmpty:(int)column
{
	for (int i = 0;i < kLastRow; i++)
	{
		if (board[column][i])
		{
			return NO;
		}
	}
	return YES;
}

- (void)moveTetrominoDown
{
	//for each block of the tetronimo
	for (Block *currentBlock in userTetromino.children)
	{
		//Gets next block
		Block *blockUnderCurrentBlock = board[currentBlock.boardX][currentBlock.boardY + 1];
		if (!([userTetromino isBlockInTetromino:blockUnderCurrentBlock]))
		{
			
			//If the block is at the bottom or there's a block under. It's stuck!
			if (currentBlock.boardY == kLastRow ||
				(board[currentBlock.boardX][currentBlock.boardY + 1] != nil))
			{
				userTetromino.stuck = YES;
				[self checkForLinesToClear];
			}
		}
	}
		
	//If the block is not stuck move it down
	if (!userTetromino.stuck)
	{
		// Reverse block enumerator so they dont overlap when you're shifting down
		CCArray *reversedBlockArray = [[CCArray alloc] initWithArray:userTetromino.children];  
		[reversedBlockArray reverseObjects];
		
		for (Block* currentBlock in reversedBlockArray)
		{
			board[currentBlock.boardX][currentBlock.boardY] = nil;
			board[currentBlock.boardX][currentBlock.boardY + 1] = currentBlock;
		}
		
		//???: Redundant loops through all the blocks again?
		[userTetromino moveTetrominoDown];
		
	}
}


- (void)moveTetrominoLeft
{
	if ([self canMoveTetrominoByX:-1])
	{
		CCArray *reversedBlockArray = [[CCArray alloc] initWithArray:userTetromino.children];
		
		for (Block* currentBlock in reversedBlockArray)
		{
			[self moveBlockInBoardX:currentBlock byX:-1];
		}
		
		userTetromino.anchorX -= 1;
	}
}


- (void)moveTetrominoRight
{
	if ([self canMoveTetrominoByX:1])
	{
		
		CCArray *reversedBlockArray = [[CCArray alloc] initWithArray:userTetromino.children];
		[reversedBlockArray reverseObjects];
		
		for (Block* currentBlock in reversedBlockArray)
		{
			[self moveBlockInBoardX:currentBlock byX:1];
		}
		
		userTetromino.anchorX += 1;
	}
	
}

//Stay here because it needs to know about the board
- (BOOL)canMoveTetrominoByX:(int)offSetX
{
	// Sort blocks by x value if moving left, reverse order if moving right
	CCArray *reversedChildren = [[CCArray alloc] initWithArray:userTetromino.children];
	
	if (offSetX > 0)
	{
		[reversedChildren reverseObjects]; 
	}
	
	for (Block *currentBlock in reversedChildren)
	{
		Block *blockNextToCurrentBlock = board[currentBlock.boardX + offSetX][currentBlock.boardY];
		//dont compare yourself
		if (!([userTetromino isBlockInTetromino:blockNextToCurrentBlock]))
		{
			//if there's another block at the position you're looking at, you can't move
			if (board[currentBlock.boardX + offSetX][currentBlock.boardY] != nil)
			{
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
		touchType = kDropBlocks;
	}
	
	else if (location.x < leftMostX)
	{
		touchType = kMoveLeft;
	}
	else if (location.x > rightMostX)
	{
		touchType = kMoveRight;
	}
	
	[self processTaps];
	
	
}

- (BOOL)isTetrominoInBounds:(Tetromino *)rotated
{
    for (Block *currentBlock in rotated.children)
	{
		//check if the new block is within the bounds and
		if(currentBlock.boardX < 0 || currentBlock.boardX > kLastColumn || currentBlock.boardY < 0 || currentBlock.boardY > kLastRow )
		{
			NSLog(@"DENIED");
			return NO;
			
		}
		
		Block *blockInCurrentBoard = board[currentBlock.boardX][currentBlock.boardY];
		//if the current block is NOT part of the currentTetromino
		if (!([userTetromino isBlockInTetromino:blockInCurrentBoard]))
		{
			//and is not empty
			if (board[currentBlock.boardX][currentBlock.boardY] != nil)
			{
				NSLog(@"DENIED");
				return NO;
			}
		}
	}
	return YES;
}

- (void)removeTetrominoFromBoard:(Tetromino *)tetrominoToDelete
{
	//Delete old tetromino
    for (Block *currentBlock in tetrominoToDelete.children)
	{
		board[currentBlock.boardX][currentBlock.boardY] = nil;
		
	}
    [self removeChild:tetrominoToDelete cleanup:YES];
    [tetrominoInGame removeObject:tetrominoToDelete];
}

- (void)rotateTetromino:(RotationDirection)direction
{
    Tetromino *rotated = [Tetromino blockWithType:userTetromino.type Direction:direction BoardX:userTetromino.anchorX BoardY:userTetromino.anchorY CurrentOrientation:userTetromino.orientation];
    
	//check if the rotated Tetromino within the bounds of the board
	if([self isTetrominoInBounds:rotated])
	{
		[self removeTetrominoFromBoard:userTetromino];
		
		//add rotated to board
		for (Block *currentBlock in rotated.children)
		{
			board[currentBlock.boardX][currentBlock.boardY] = currentBlock;
		}
		
		userTetromino = rotated;
		[self addChild:userTetromino];
	}
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

	
}


//Helper function to recalculate left and right block positions
- (void)moveBlockInBoardX:(Block *)block byX:(int)offsetX
{
	//double checking to see if there's nothing
	if (board[block.boardX + offsetX][block.boardY] == nil)
	{
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
