//
// Created by Nicolas Martin on 13-08-15.
//
//

#import "CCLayer.h"
#import "GameLogicLayer.h"
#import "CCNode+SFGestureRecognizers.h"
#import "Field.h"
#import "GameController.h"
#import "Board.h"
#import "Inventory.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
GameController *gameController1;
GameController *gameController2;
GameController *gameController3;

GameController *gameController4;

@interface GameLogicLayer (private)

- (void)startGame;

@end

@implementation GameLogicLayer
{
}

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];

    GameLogicLayer *layer = [[GameLogicLayer alloc] init];
    [scene addChild: layer];

    return scene;
}

- (id)init {

	if ((self = [super init]))
	{
        playerWidth = 160;
        playerHeight = 336;
        playerTileSize = 16;

        mainWidth = 320;
        mainHeight = 672;
        mainTileSize = 32;

        _MainField = [Field node];
        _FieldLayer1 = [Field node];
        _FieldLayer2 = [Field node];
        _FieldLayer3 = [Field node];
        _FieldLayer4 = [Field node];

        Board *mainBoard = [Board initBoard];
        Board *player1Board = [Board initBoard];
        Board *player2Board = [Board initBoard];
        Board *player3Board = [Board initBoard];
        Board *player4Board = [Board initBoard];

        [_MainField initWithName:@"MainField" TileSize:32 Height:640 Width:320 board:mainBoard];
        [_FieldLayer1 initWithName:@"Field1" TileSize:16 Height:320 Width:160 board:player1Board];
        [_FieldLayer2 initWithName:@"Field2" TileSize:16 Height:320 Width:160 board:player2Board];
        [_FieldLayer3 initWithName:@"Field3" TileSize:16 Height:320 Width:160 board:player3Board];
        [_FieldLayer4 initWithName:@"Field4" TileSize:16 Height:320 Width:160 board:player4Board];

        CGSize winSize = [CCDirector sharedDirector].winSize;
        NSUInteger rightMargin = 50;
        NSUInteger topMargin = 20;
        NSUInteger bottomMargin = 20;
        NSUInteger padBetweenField = 250;

        [_MainField setPosition:ccp(20,70)];
        [_MainField setContentSize:CGSizeMake(mainWidth, mainHeight)];

        [_FieldLayer1 setPosition:ccp((winSize.width - rightMargin) - playerWidth, bottomMargin)];
        [_FieldLayer1 setContentSize:CGSizeMake(playerWidth, playerHeight)];

        [_FieldLayer2 setPosition:ccp((winSize.width - rightMargin) - playerWidth, (winSize.height - topMargin) - playerHeight)];
        [_FieldLayer2 setContentSize:CGSizeMake(playerWidth, playerHeight)];


        [_FieldLayer3 setPosition:ccp((winSize.width - rightMargin) - (playerWidth + padBetweenField), bottomMargin)];
        [_FieldLayer3 setContentSize:CGSizeMake(playerWidth, playerHeight)];

        [_FieldLayer4 setPosition:ccp((winSize.width - rightMargin) - (playerWidth + padBetweenField), (winSize.height - topMargin) - (playerHeight))];
        _FieldLayer4.contentSize = CGSizeMake(playerWidth, playerHeight);

        [self addChild:_MainField z:-1];
        [self addChild:_FieldLayer1 z:-1];
        [self addChild:_FieldLayer2 z:-1];
        [self addChild:_FieldLayer3 z:-1];
        [self addChild:_FieldLayer4 z:-1];

        self.isTouchEnabled = YES;

        //Creates a new controller with a field.
        _gameController = [GameController controllerWithField:_MainField isMain:YES ];

        //////// TESTING ////////
        gameController1 = [GameController controllerWithField:_FieldLayer1 isMain:NO ];
        gameController2 = [GameController controllerWithField:_FieldLayer2 isMain:NO];
        gameController3 = [GameController controllerWithField:_FieldLayer3 isMain:NO];
        gameController4 = [GameController controllerWithField:_FieldLayer4 isMain:NO];
//        Block *block = [Block blockWithBlockType:2];
//        [block setBoardX:5];
//        [block setBoardY:7];
//        NSMutableArray *bArray = [NSMutableArray array];
//        [bArray addObject:block];
//        [gameController1.field addBlocks:bArray];
        //////// TESTING ////////

        _MainField.isTouchEnabled = YES;
		UISwipeGestureRecognizer *swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightGestureRecognizer:)];
		swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
		swipeRightGestureRecognizer.delegate = self;
		[_MainField addGestureRecognizer:swipeRightGestureRecognizer];

		UISwipeGestureRecognizer *swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftGestureRecognizer:)];
		swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
		swipeLeftGestureRecognizer.delegate = self;
		[_MainField addGestureRecognizer:swipeLeftGestureRecognizer];

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapGestureRecognizer.delegate = self;
        [_MainField addGestureRecognizer:tapGestureRecognizer];

        _gameController.inventory.isTouchEnabled = YES;
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:_gameController.inventory priority:0 swallowsTouches:NO];

        [self setInventoryFieldBoxes];
        [self startGame];
	
	}
	return self;
}

- (void)setInventoryFieldBoxes {
    NSMutableDictionary *mainFieldBoxWithName = [NSMutableDictionary dictionary];
    NSMutableDictionary *field1BoxWithName = [NSMutableDictionary dictionary];
    NSMutableDictionary *field2BoxWithName = [NSMutableDictionary dictionary];
    NSMutableDictionary *field3BoxWithName = [NSMutableDictionary dictionary];
    NSMutableDictionary *field4BoxWithName = [NSMutableDictionary dictionary];

    [mainFieldBoxWithName setObject:[NSValue valueWithCGRect:_MainField.boundingBox] forKey:@"MainField"];
    [field1BoxWithName setObject:[NSValue valueWithCGRect:_FieldLayer1.boundingBox] forKey:@"Field1"];
    [field2BoxWithName setObject:[NSValue valueWithCGRect:_FieldLayer2.boundingBox] forKey:@"Field2"];
    [field3BoxWithName setObject:[NSValue valueWithCGRect:_FieldLayer3.boundingBox] forKey:@"Field3"];
    [field4BoxWithName setObject:[NSValue valueWithCGRect:_FieldLayer4.boundingBox] forKey:@"Field4"];

    [_gameController.inventory.fieldBoundingBoxes addObject:mainFieldBoxWithName];
    [_gameController.inventory.fieldBoundingBoxes addObject:field1BoxWithName];
    [_gameController.inventory.fieldBoundingBoxes addObject:field2BoxWithName];
    [_gameController.inventory.fieldBoundingBoxes addObject:field3BoxWithName];
    [_gameController.inventory.fieldBoundingBoxes addObject:field4BoxWithName];
}

- (Field *)getFieldFromString:(NSString *)fieldName
{
    if ([fieldName isEqualToString:@"MainField"])
    {
        return _MainField;
    }
    else if ([fieldName isEqualToString:@"Field1"])
    {
        return _FieldLayer1;
    }
    else if ([fieldName isEqualToString:@"Field2"])
    {
        return _FieldLayer2;
    }
    else if ([fieldName isEqualToString:@"Field3"])
    {
        return _FieldLayer3;
    }
    else if ([fieldName isEqualToString:@"Field4"])
    {
        return _FieldLayer4;
    }
    else
    {
        return nil;
    }
}


- (void)handleTap:(UITapGestureRecognizer *)sender
{

    CGPoint location = [sender locationInView: [sender view]];

    [_gameController viewTap:[self tileCoordForPosition:location]];
}



-(void)AddBlocksToPlayer:(GameController *)controller blocksToAdd:(NSMutableArray *)blocks
{

}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
    NSUInteger x = (NSUInteger) (position.x / mainTileSize);
    NSUInteger y = (NSUInteger) (20-(((mainHeight) - position.y) / mainTileSize));
    return ccp(x, y);
}

- (void)swipeRightGestureRecognizer:(UISwipeGestureRecognizer*)aGestureRecognizer
{
	[_gameController rotateTetromino:rotateClockwise];
	
}

- (void)swipeLeftGestureRecognizer:(UISwipeGestureRecognizer*)aGestureRecognizer
{
	[_gameController rotateTetromino:rotateCounterclockwise];
	
}

- (void)startGame{


	[_gameController createNewTetromino];
    //////// TESTING ////////
//    [gameController1 createNewTetromino];
//    [gameController2 createNewTetromino];
//    [gameController3 createNewTetromino];
//    [gameController4 createNewTetromino];
    //////// TESTING ////////

	frameCount = 0;
	moveCycleRatio = 10;
    [self schedule:@selector(updateBoard:) interval:(1.0 / 60.0)];
}

- (id)initWithFields:(Field *)mainFieldLayer and:(Field *)otherFieldLayer1 and:(Field *)otherFieldLayer2 and:(Field *)otherFieldLayer3 and:(Field *)otherFieldLayer4 {
    return nil;
}

- (void)updateBoard:(ccTime)dt  {
    frameCount += 1;
    if (frameCount % moveCycleRatio == 0)
    {
        [_gameController moveDownOrCreate];
        //////// TESTING ////////
//        [gameController1 moveDownOrCreate];
//        [gameController2 moveDownOrCreate];
//        [gameController3 moveDownOrCreate];
//        [gameController4 moveDownOrCreate];
        //////// TESTING ////////

    }
}

@end
