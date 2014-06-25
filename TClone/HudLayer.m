//
// Created by Nicolas Martin on 11/29/2013.
//


#import "HudLayer.h"
#import "CCLabelTTF.h"
#import "CCDirector.h"


@implementation HudLayer {
    CCLabelTTF  *_label;
}


- (id)init {
    self = [super init];
    if (self) {
        CGSize winSize = [CCDirector sharedDirector].viewSize;
        _label = [CCLabelTTF labelWithString:@"0" fontName:@"Helvetica" fontSize:18.0];
        _label.color = [CCColor blackColor];
        NSUInteger margin = 10;
        //_label.position = ccp(winSize.width - (_label.contentSize.width/2) - margin, _label.contentSize.height/2 + margin);
        _label.position = ccp(0,0);

        [self addChild:_label];

    }

    return self;
}

+ (id)initLayer {
    return [[self alloc] init];
}

- (void)numRowClearedChanged:(int)numRowCleared {
    _label.string = [NSString stringWithFormat:@"%d", numRowCleared];

}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"LayerPosition=%@", self.position];
    [description appendFormat:@"LabelPosition=%@", _label.position];
    [description appendFormat:@"Text=%@", _label.string];
    [description appendString:@">"];
    return description;
}


@end