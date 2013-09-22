//
//  TitleView.m
//  AlbumCollection
//
//  Created by Hiroki Yoshifuji on 2013/09/20.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "TitleView.h"

@implementation TitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        CGRect labelRect = CGRectMake(4, 4, frame.size.width - 8, frame.size.height - 8);
        UILabel* label = [[UILabel alloc] initWithFrame:labelRect];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.autoresizingMask = (UIViewAutoresizingFlexibleWidth|
                                  UIViewAutoresizingFlexibleHeight|
                                  UIViewAutoresizingFlexibleLeftMargin|
                                  UIViewAutoresizingFlexibleTopMargin|
                                  UIViewAutoresizingFlexibleRightMargin|
                                  UIViewAutoresizingFlexibleBottomMargin);
        label.backgroundColor = [UIColor yellowColor];
        label.layer.cornerRadius = 5.0f;
        label.layer.borderColor = [UIColor whiteColor].CGColor;
        label.layer.borderWidth = 2.0f;
        [self addSubview:label];
        self.titleLabel = label;
    }
    return self;
}


@end
