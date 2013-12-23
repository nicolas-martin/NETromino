//
// Created by Nicolas Martin on 13-08-15.
//
//

#import "cocos2d.h"


#define kLastColumn 9
#define kLastRow 19
#define rowoffset 3

typedef enum
{
	I_block,
	O_block,
	J_block,
	L_block,
	Z_block,
	S_block,
	T_block
} tetrominoType;


typedef enum
{
	rotateCounterclockwise = -1,
	rotateNone = 0,
	rotateClockwise = 1
} RotationDirection;

typedef enum
{
    moveLeft = -1,
    moveNone = 0,
    moveRight = 1
} MoveDirection;

@interface Tetromino : CCSprite
{
	BOOL stuck;	
	CGPoint leftMostPosition;
	CGPoint rightMostPosition;
    //NSUInteger orientation;

}

@property (readwrite, assign) NSUInteger orientation;
@property (readwrite, strong) NSMutableArray *blocksInTetromino;
@property (assign) BOOL stuck;
@property (readwrite, assign) NSUInteger anchorX;
@property (readwrite, assign) NSUInteger anchorY;
@property (readwrite, assign, nonatomic) CGPoint leftMostPosition;
@property (readwrite, assign, nonatomic) CGPoint rightMostPosition;
@property (readwrite, assign, nonatomic) CGPoint highestPosition;
@property (readwrite, assign, nonatomic) CGPoint lowestPosition;
@property (nonatomic) tetrominoType type;

+ (id)randomBlockUsingBlockFrequency:(BOOL)isMain;

- (id)initWithRandomTypeAndOrientationUsingFrequency:(BOOL)isMain;

+ (id)blockWithType:(tetrominoType)blockType Direction:(RotationDirection)blockOrientation BoardX:(NSUInteger)positionX BoardY:(NSUInteger)positionY CurrentOrientation:(NSUInteger)CurrentOrientation;

- (BOOL)isBlockInTetromino:(id)block;

- (void)moveTetrominoInDirection:(Tetromino *)tetromino inDirection:(MoveDirection)direction;

+ (Tetromino *)rotateTetromino:(Tetromino *)userTetromino in:(RotationDirection)direction;

- (void)moveTetrominoDown;

- (void)MoveBoardPosition:(Tetromino *)ToTetromino;

- (NSString *)description;

@end
