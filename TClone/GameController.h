//
// Created by Nicolas Martin on 13-08-15.
//
//

#import "Tetromino.h"
#import "Field.h"

@class HudLayer;

@protocol GameControllerObserver <NSObject>

@optional
- (void)updateTetrominoPosition:(Tetromino *)tetromino;
@end


@interface GameController : NSObject <NSCoding> {

    Tetromino *userTetromino;

    enum touchTypes {
        kNone,
        kDropBlocks,
        kMoveLeft,
        kMoveRight
    } touchType;

}

@property (nonatomic, strong) NSMutableArray* listObservers;
@property (assign) NSUInteger numRowClearedd;
@property (nonatomic, strong) Field *field;
@property (strong) HudLayer * hudLayer;

- (id)initWithField:(Field *)aField;

+ (id)controllerWithField:(Field *)aField;

- (void)numCollectedChanged:(int)numCollected;

- (void)VerifyNewBlockCollision:(Tetromino *)new;

- (void)addBlocks:(NSMutableArray *)blocksToAdd;

- (void) createNewTetromino;

- (void)rotateTetromino:(RotationDirection)direction;

- (void)viewTap:(CGPoint)location;

- (void)moveDownOrCreate;

@end