//
// Created by Nicolas Martin on 13-08-15.
//
//

#import "Tetromino.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@interface Tetromino (private)
- (void)initializeTetromino;
@end

@implementation Tetromino

typedef uint8_t BLOCK[4][4];
static BLOCK bI[2] = {
        {
                {0,0,0,0},
                {1,1,1,1},
                {0,0,0,0},
                {0,0,0,0}
        }, {
                {0,1,0,0},
                {0,1,0,0},
                {0,1,0,0},
                {0,1,0,0}
        }
};
static BLOCK bO[1] = {
        {
                {0,2,2,0},
                {0,2,2,0},
                {0,0,0,0},
                {0,0,0,0}
        }
};
static BLOCK bJ[4] = {
        {
                {3,0,0,0},
                {3,3,3,0},
                {0,0,0,0},
                {0,0,0,0}
        }, {
                {0,3,3,0},
                {0,3,0,0},
                {0,3,0,0},
                {0,0,0,0}
        }, {
                {0,0,0,0},
                {3,3,3,0},
                {0,0,3,0},
                {0,0,0,0}
        }, {
                {0,3,0,0},
                {0,3,0,0},
                {3,3,0,0},
                {0,0,0,0}
        },
};
static BLOCK bL[4] = {
        {
                {0,0,4,0},
                {4,4,4,0},
                {0,0,0,0},
                {0,0,0,0}
        }, {
                {0,4,0,0},
                {0,4,0,0},
                {0,4,4,0},
                {0,0,0,0}
        }, {
                {0,0,0,0},
                {4,4,4,0},
                {4,0,0,0},
                {0,0,0,0}
        }, {
                {4,4,0,0},
                {0,4,0,0},
                {0,4,0,0},
                {0,0,0,0}
        }
};
static BLOCK bZ[2] = {
        {
                {5,5,0,0},
                {0,5,5,0},
                {0,0,0,0},
                {0,0,0,0}
        }, {
                {0,0,5,0},
                {0,5,5,0},
                {0,5,0,0},
                {0,0,0,0}
        }
};
static BLOCK bS[2] = {
        {
                {0,1,1,0},
                {1,1,0,0},
                {0,0,0,0},
                {0,0,0,0}
        }, {
                {1,0,0,0},
                {1,1,0,0},
                {0,1,0,0},
                {0,0,0,0}
        }
};
static BLOCK bT[4] = {
        {
                {0,2,0,0},
                {2,2,2,0},
                {0,0,0,0},
                {0,0,0,0}
        }, {
                {0,2,0,0},
                {0,2,2,0},
                {0,2,0,0},
                {0,0,0,0}
        }, {
                {0,0,0,0},
                {2,2,2,0},
                {0,2,0,0},
                {0,0,0,0}
        }, {
                {0,2,0,0},
                {2,2,0,0},
                {0,2,0,0},
                {0,0,0,0}
        }
};
//This is a 2D array
static BLOCK *blocks[7] = {bI, bO, bJ, bL, bZ, bS, bT};
static NSInteger orientationCount[7] = {2, 1, 4, 4, 2, 2, 4};




- (BLOCK*)contents
{
	return &(blocks[type][orientation]);
}

- (BLOCK*)contents:(tetrominoType)currentType and:(NSUInteger)currentOrientation
{
    return &(blocks[currentType][currentOrientation]);
}


+ (id)blockWithType:(tetrominoType)blockType Direction:(RotationDirection)blockOrientation BoardX:(NSInteger)positionX BoardY:(NSInteger)positionY CurrentOrientation:(NSInteger)CurrentOrientation;
{
	return [[self alloc] initWithTypeRotationPosition:blockType rotationDirection:blockOrientation BoardX:positionX BoardY:positionY CurrentOrientation:CurrentOrientation];
}

- (id)initWithTypeRotationPosition:(tetrominoType)blockType rotationDirection:(RotationDirection)blockDirection BoardX:(NSInteger)positionX BoardY:(NSInteger)positionY CurrentOrientation:(NSInteger)CurrentOrientation;
{
	if (self = [super init])
	{
		self.anchorX = positionX;
		self.anchorY = positionY;
		type = blockType;
		orientation = CurrentOrientation;

		orientation = (orientation + blockDirection + [self numOrientations]) % [self numOrientations];

		_blocksInTetromino = [[NSMutableArray alloc] init];
		
		BLOCK* contents = [self contents];

		for (NSInteger row = 0; row < 4; row++)
		{
			for (NSInteger col = 0; col < 4; col++)
			{
				// Get the contents of this cell of the block
				uint8_t cellType = (*contents)[(4 - 1) - row][col];

				// If the cell is empty, skip to the next iteration of the Ïloop
				if (cellType == 0)
					continue;
				
				Block *newBlock = [Block newEmptyBlockWithColorByType:type];
				newBlock.boardX = (row + _anchorX);
				newBlock.boardY = col + _anchorY;
                //copmute?
				newBlock.position = ccp(newBlock.boardX, newBlock.boardY);
				[self addChild:newBlock];
				[_blocksInTetromino addObject:newBlock];
				
			}
		}
		
		[self initializeTetromino];
		
	}
	return self;

}

- (NSInteger)numOrientations
{
	return orientationCount[type];
}


+ (id)randomBlockUsingBlockFrequency
{
	return [[self alloc] initWithRandomTypeAndOrientationUsingFrequency];
}

//This works with random orientation and random types!!
- (id)initWithRandomTypeAndOrientationUsingFrequency
{

	if (self = [super init])
	{
		
		int blockFrequency = arc4random() % 7;
		type = (tetrominoType)blockFrequency;
		int randomOrientation = arc4random() % orientationCount[type];
				
		
		
		orientation = randomOrientation;
		_blocksInTetromino = [[NSMutableArray alloc] init];
				
		BLOCK* contents = [self contents];
		
		self.anchorX = rowoffset;
		self.anchorY = 0;
		
		for (NSInteger row = 0; row < 4; row++)
		{
			for (NSInteger col = 0; col < 4; col++)
			{
				// Get the contents of this cell of the block
				uint8_t cellType = (*contents)[(4 - 1) - row][col];
				
				// If the cell is empty, skip to the next iteration of the loop
				if (cellType == 0)	
					continue;
			

				Block *newBlock = [Block newEmptyBlockWithColorByType:type];
				newBlock.boardX = row + _anchorX;
				newBlock.boardY = col + _anchorY;

				newBlock.position = ccp(newBlock.boardX, newBlock.boardY );
				[self addChild:newBlock];
				[_blocksInTetromino addObject:newBlock];
				
			}
		}
				
		[self initializeTetromino];
		
	}
	return self;
}

- (id)initWithType:(tetrominoType)blockType
	   orientation:(NSInteger)blockOrientation
{
	type = blockType;
	orientation = (blockOrientation % orientationCount[type]);
	
	return self;
}



- (void)initializeTetromino
{
	self.stuck = NO;
	//[self setShape];
	/*Block *firstBlock = [children_ objectAtIndex:0];
	self.anchorX = firstBlock.boardX;
	self.anchorY = firstBlock.boardY;*/
	self.anchorPoint = ccp(0,0);
}

- (BOOL)stuck
{
	for (Block *block in self.children) {
		stuck = block.stuck;
	}
	return stuck;
}

- (void)setStuck:(BOOL)stuckValue
{
	stuck = stuckValue;
	for (Block *block in self.children) {
		block.stuck = stuckValue;
	}
}

- (BOOL)isBlockInTetromino:(id)block
{
	for (Block *currentBlock in self.children) {
		if ([currentBlock isEqual:block]) {
			return YES;
		}
	}
	return NO;
}

- (void)moveTetrominoInDirection:(Tetromino *)tetromino inDirection:(MoveDirection)direction
{
//     CCArray *reversedBlockArray = [[CCArray alloc] initWithArray:tetromino.children];
//    [reversedBlockArray reverseObjects];

    //TODO: Add board verification
    for (Block* currentBlock in tetromino.children)
    {
        [currentBlock moveByX:direction];
    }

    tetromino.anchorX += direction;
}

+ (Tetromino *)rotateTetromino:(Tetromino *)userTetromino in:(RotationDirection)direction {

    //TODO: Create a new tetromino with the current tetromino position in the new direction

    //return [Tetromino blockWithType:userTetromino.type Direction:direction BoardX:userTetromino.anchorX BoardY:userTetromino.anchorY CurrentOrientation:userTetromino.orientation];

    return nil;
}

- (void)moveTetrominoDown {

	CCArray *reversedChildren = [[CCArray alloc] initWithArray:self.children];  // make copy
	[reversedChildren reverseObjects]; // reverse contents
	
	for (Block *currentBlock in reversedChildren)
	{
		//move each block down
		[currentBlock moveDown];
	}



	self.anchorY += 1;	
}

//TODO: Make sure these return the x and y like in "math"
- (CGPoint)leftMostPosition
{
	
	CGPoint	myLeftPosition = ccp(999,999);
	for (Block *currentBlock in self.children) {
		if ( myLeftPosition.x > currentBlock.boardX) {
			myLeftPosition = ccp(currentBlock.boardX, currentBlock.boardY);
		}
	}
	return myLeftPosition;
	
}

- (CGPoint)rightMostPosition
{
	CGPoint myRightPosition = ccp(-1, -1);
	for (Block *currentBlock in self.children) {
		if (myRightPosition.x < currentBlock.boardX) {
			myRightPosition = ccp(currentBlock.boardX, currentBlock.boardY);
		}
	}
	return myRightPosition;
}

- (CGPoint)highestPosition
{
	
	CGPoint	myLeftPosition = ccp(999,999);
	for (Block *currentBlock in self.children) {
		if ( myLeftPosition.y > currentBlock.boardY) {
			myLeftPosition = ccp(currentBlock.boardX, currentBlock.boardY);

		}
	}
	return myLeftPosition;
	
}

- (CGPoint)getLowestPosition
{
	CGPoint myRightPosition = ccp(-1, -1);
	for (Block *currentBlock in self.children) {
		if (myRightPosition.y < currentBlock.boardY) {
			myRightPosition = ccp(currentBlock.boardX, currentBlock.boardY);
		}
	}
	return myRightPosition;
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"%@: type = %d, boardX = %d, boardY = %d, orientation = %d", [super description], type, _anchorX, _anchorY, orientation];
}

//J'ai pas besoin du tetromino en parametre pcq c'est une instance method.
- (void)setPositionUsingFieldValue:(Tetromino *)tetromino height:(int)height width:(int)width tileSize:(int)size
{
    //TODO: Take in consideration the position of the field on the screen.
    for (Block *block in tetromino.children)
    {
        //int x = (int) (position.x / mainTileSize);//500,200
        //int y = (int) (((mainHeight) - position.y) / mainTileSize);

        int x = block.boardX * size;
        int y = (-(block.boardY * size) + height);
        [block setPosition:ccp(x, y)];
    }

}
@end
