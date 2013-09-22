//
//  StackLayout.h
//  AlbumCollection
//
//  Created by Hiroki Yoshifuji on 2013/09/20.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import <UIKit/UIKit.h>

#define StackLayoutElementKindTitle @"StackLayoutElementKindTitle"

@interface StackLayout : UICollectionViewLayout

@property (nonatomic) CGSize sectionSize;
@property (nonatomic) CGSize titleReferenceSize;

@property (nonatomic) CGPoint pinchPoint;
@property (nonatomic) CGFloat pinchScale;


@end


@protocol StackLayoutDelegate <UICollectionViewDelegate>

@required
- (CGSize)collectionView:(UICollectionView*)collectioNView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end