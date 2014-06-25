//
// Created by Nicolas Martin on 13-08-15.
//
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverLayer : CCNode
{
    
}

+ (id)initLayer:(BOOL)won andContentSize:(CGSize)size;

- (id)initWithWon:(BOOL)isGameOver andSize:(CGSize)size;

@end
