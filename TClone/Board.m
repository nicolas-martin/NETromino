//
// Created by Nicolas Martin on 13-08-20.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Board.h"
#import "CGPointExtension.h"


@implementation Board {

}


- (id)init {
    self = [super init];
    if (self) {
        Nby = 20;
        Nbx = 10;
        _array = [self get20x10Array];

    }

    return self;
}

-(NSMutableArray*)get20x10Array {
    NSMutableArray* arr = [NSMutableArray array];
    for (int i = 0; i < Nbx; ++ i) {
        NSMutableArray* subarr = [NSMutableArray array];
        for (int j = 0; j < Nby; ++ j)
            //insert at index??
            [subarr addObject:[NSNumber numberWithInt:0]];
        [arr addObject:subarr];
    }
    return arr;
}

- (BOOL)blockAt:(CGPoint)point {

    NSMutableArray *inner = [_array objectAtIndex:point.x];

    if([inner objectAtIndex:point.y])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)boardRowEmpty:(int)y
{
    for (int x = 0;x < Nbx; x++)
    {
        if ([self blockAt:ccp(x, y)])
        {
            return NO;
        }
    }
    return YES;
}

//Return the row to clear or clear it myself?
- (void)clearFullRows
{
    BOOL occupied = NO;
    for (int y = 0;y < Nby; y++)
    {

        for (int x = 0; x < Nbx; ++ x){

            if(![self blockAt:ccp(x,y)])
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
            //TODO: remove row from the board
            //TODO: Notify the view

        }
        else
        {
            continue;
        }

    }


}


@end