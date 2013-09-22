//
//  ThumbnailCell.m
//  AlbumCollection
//
//  Created by Hiroki Yoshifuji on 2013/09/19.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "ThumbnailCell.h"

#import "MyLayoutAttributes.h"

@implementation ThumbnailCell

static const CGFloat borderWidth = 10.0f;

+(CGSize)sizeForImageSize:(CGSize)imageSize {
    return CGSizeMake(imageSize.width + borderWidth * 2,
                      imageSize.height + borderWidth * 2);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundView = backgroundView;
        
        
        UIView* selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        selectedBackgroundView.backgroundColor = [UIColor cyanColor];
        self.selectedBackgroundView = selectedBackgroundView;
    }
    return self;
}


- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    if ([layoutAttributes isKindOfClass:[MyLayoutAttributes class]]) {
        MyLayoutAttributes* attributes = (MyLayoutAttributes*)layoutAttributes;
        self.imageView.layer.shadowOpacity = attributes.shadowOpacity;
    } else {
        self.imageView.layer.shadowOpacity = 0.0f;
    }
}


- (void)layoutSubviews
{
    self.imageView.frame = CGRectMake(borderWidth,
                                      borderWidth,
                                      self.bounds.size.width - borderWidth * 2,
                                      self.bounds.size.height - borderWidth * 2);
}
@end
