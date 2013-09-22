//
//  HeaderView.m
//  AlbumCollection
//
//  Created by Hiroki Yoshifuji on 2013/09/20.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "HeaderView.h"

#import "MyLayoutAttributes.h"

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    if ([layoutAttributes isKindOfClass:[MyLayoutAttributes class]]) {
        MyLayoutAttributes* attributes = (MyLayoutAttributes*)layoutAttributes;
        self.titleLabel.textAlignment = attributes.headerTextAlignment;
    } else {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
}


@end
