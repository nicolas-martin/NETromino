//
// Created by Nicolas Martin on 13-08-15.
//
//

#import "GameOverLayer.h"
#import "GameLogicLayer.h"

@implementation GameOverLayer

+ (id)initLayer:(BOOL)won andContentSize:(CGSize)size {
    return [[self alloc] initWithWon:won andSize:size];
}

- (id)initWithWon:(BOOL)isGameOver andSize:(CGSize)size {
    if ((self = [super init])) {
        
        NSString * message;
        if (isGameOver) {
            message = @"You Lose.";
        } else {
            message = @"You Won!";
        }



        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:32];
        [label setAnchorPoint:ccp(0,0)];
        label.color = [CCColor greenColor];
        [label setPosition:ccp(size.width/2, size.height/2)];

        [self setAnchorPoint:ccp(0, 0)];
        [self addChild:label];

        [self setZOrder:2];

    }
    return self;
}

@end