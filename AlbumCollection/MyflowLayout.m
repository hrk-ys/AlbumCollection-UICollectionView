//
//  MyflowLayout.m
//  AlbumCollection
//
//  Created by Hiroki Yoshifuji on 2013/09/20.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "MyflowLayout.h"

#import "MyLayoutAttributes.h"

@interface MyflowLayout()
@property (nonatomic) NSMutableArray* deletedIndexPaths;
@end

@implementation MyflowLayout

+(Class)layoutAttributesClass
{
    return [MyLayoutAttributes class];
}

- (void)setupItemAttributes:(MyLayoutAttributes*)attributes {
    attributes.transform3D = CATransform3DMakeRotation(5.0*M_PI / 180.0, 0, 0, 1);
    attributes.shadowOpacity = 0.5f;
}

- (void)setupSupplementaryViewAttributes:(MyLayoutAttributes*)atttibutes
{
    if (atttibutes.representedElementKind == UICollectionElementKindSectionHeader) {
        atttibutes.alpha = 0.5;
        atttibutes.headerTextAlignment = NSTextAlignmentCenter;
    }
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* attributesArray = [super layoutAttributesForElementsInRect:rect];
    for (MyLayoutAttributes* attributes in attributesArray) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
            [self setupItemAttributes:attributes];
        } else if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView) {
            [self setupSupplementaryViewAttributes:attributes];
        }
    }
    
    return attributesArray;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyLayoutAttributes* attributes = (MyLayoutAttributes*)[super layoutAttributesForItemAtIndexPath:indexPath];
    [self setupItemAttributes:attributes];
    return attributes;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    MyLayoutAttributes* attributes = (MyLayoutAttributes*)[super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    [self setupSupplementaryViewAttributes:attributes];
    return attributes;
}



- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    self.deletedIndexPaths = @[].mutableCopy;
    for (UICollectionViewUpdateItem* updateItem in updateItems) {
        if (updateItem.updateAction == UICollectionUpdateActionDelete) {
            [self.deletedIndexPaths addObject:updateItem.indexPathBeforeUpdate];
        }
    }
}


- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    if ([self.deletedIndexPaths containsObject:itemIndexPath]) {
        UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
        CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x,
                                        self.collectionView.contentOffset.y,
                                        self.collectionView.bounds.size.width,
                                        self.collectionView.bounds.size.height);
        
        attributes.center = CGPointMake(CGRectGetMidX(visibleRect),
                                        CGRectGetMidY(visibleRect));
        attributes.transform3D = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        
        attributes.alpha = 0;
        
        return attributes;
    } else {
        return [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    }
}

- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    self.deletedIndexPaths = nil;
}
@end
