//
// Created by Nicolas Martin on 13-08-15.
//
//


#import "Tetromino.h"

@class Field;
@class HudLayer;
@class Inventory;

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

@property NSMutableArray* listObservers;
@property NSUInteger numRowCleared;
@property Field *field;
@property HudLayer * hudLayer;
@property Inventory * inventory;

- (id)initWithField:(Field *)aField;

+ (id)controllerWithField:(Field *)aField;

- (void)VerifyNewBlockCollision:(Tetromino *)new;

- (void) createNewTetromino;

- (void)rotateTetromino:(RotationDirection)direction;

- (void)viewTap:(CGPoint)location;

- (void)moveDownOrCreate;

@end