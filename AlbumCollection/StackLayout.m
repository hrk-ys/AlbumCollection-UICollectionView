//
//  StackLayout.m
//  AlbumCollection
//
//  Created by Hiroki Yoshifuji on 2013/09/20.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "StackLayout.h"
#import "GradientView.h"


@interface StackLayout ()

@property (nonatomic) NSMutableArray *cellFrames;
@property (nonatomic) NSMutableArray *titleFrames;
@property (nonatomic) CGSize          contentSize;
@property (nonatomic) NSMutableArray *decorationFrames;

@end



@implementation StackLayout
- (id)init {
    self = [super init];
    if (self) {
        [self registerClass:[GradientView class]
    forDecorationViewOfKind:[GradientView elementKind]];
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.cellFrames = @[].mutableCopy;
    self.titleFrames = @[].mutableCopy;
    self.decorationFrames = @[].mutableCopy;
    
    NSInteger numOfSections = [self.collectionView numberOfSections];
    if (numOfSections == 0) return;
    
    CGFloat contentWidth = self.collectionView.frame.size.width;
    
    NSInteger numOfSectionsInRow;
    if (self.sectionSize.width > contentWidth) {
        numOfSectionsInRow = 1;
    } else {
        numOfSectionsInRow = (NSInteger)floorf(contentWidth / self.sectionSize.width);
    }
    
    
    CGFloat centerx = self.sectionSize.width / 2.0f;
    CGFloat centery = self.sectionSize.height / 2.0f;
    
    CGFloat contentHeigh = self.sectionSize.height + self.titleReferenceSize.height;
    
    for (int i = 0; i < numOfSections; i++) {
        NSMutableArray* mutableArray = [NSMutableArray array];
        NSInteger numOfItems = [self.collectionView numberOfItemsInSection:i];
        
        for (int j = 0; j < numOfItems; j++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            
            id<StackLayoutDelegate> delegate = (id<StackLayoutDelegate>)self.collectionView.delegate;
            CGSize itemSize = [delegate collectionView:self.collectionView
                                                layout:self
                                sizeForItemAtIndexPath:indexPath];
            
            CGRect cellFrame = CGRectMake(centerx - itemSize.width / 2.0f,
                                          centery - itemSize.height / 2.0f,
                                          itemSize.width,
                                          itemSize.height);
            
            mutableArray[j] = [NSValue valueWithCGRect:cellFrame];
        }
        
        self.cellFrames[i] = mutableArray;
        
        CGRect titleFrame = CGRectMake(centerx - self.titleReferenceSize.width / 2.0f,
                                       centery + self.sectionSize.height / 2.0f,
                                       self.titleReferenceSize.width,
                                       self.titleReferenceSize.height);
        self.titleFrames[i] = [NSValue valueWithCGRect:titleFrame];
        
        CGRect decorationFrame = CGRectMake(centerx - self.sectionSize.width / 2.0f,
                                            centery - self.sectionSize.height / 2.0f,
                                            self.sectionSize.width,
                                            self.sectionSize.height + self.titleReferenceSize.height);
        self.decorationFrames[i] = [NSValue valueWithCGRect:decorationFrame];
        
        
        if ((i+1) % numOfSectionsInRow == 0) {
            centerx = self.sectionSize.width / 2.0f;
            centery += self.sectionSize.height + self.titleReferenceSize.height;
            if ((i+1) < numOfSections) {
                contentHeigh += (self.sectionSize.height + self.titleReferenceSize.height);
            }
        } else {
            centerx += self.sectionSize.width;
        }
    }
    self.contentSize = CGSizeMake(contentWidth, contentHeigh);
}

- (CGSize)collectionViewContentSize
{
    return self.contentSize;
}

- (UICollectionViewLayoutAttributes*) layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSArray* frames = self.cellFrames[indexPath.section];
    attributes.frame = [frames[indexPath.item] CGRectValue];
    
    CGFloat angle = indexPath.item * 20.0
    / [self.collectionView numberOfItemsInSection:indexPath.section] - 10;
    attributes.transform3D = CATransform3DMakeRotation(angle*M_PI / 180.0f, 0, 0, 1);
    
    attributes.zIndex=-indexPath.item;
    if (self.pinchScale > 0 && CGRectContainsPoint(attributes.frame, self.pinchPoint)) {
        CATransform3D scale = CATransform3DMakeScale(self.pinchScale, self.pinchScale, 1);
        attributes.transform3D = CATransform3DConcat(attributes.transform3D, scale);
    }
 
    return attributes;
}

- (UICollectionViewLayoutAttributes* )layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
    if ([kind isEqualToString:StackLayoutElementKindTitle]) {
        attributes.frame = [self.titleFrames[indexPath.section] CGRectValue];
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    if ([decorationViewKind isEqualToString:[GradientView elementKind]]) {
        attributes.frame = [self.decorationFrames[indexPath.section] CGRectValue];
        
        NSInteger numOfItems = [self.collectionView numberOfItemsInSection:indexPath.section];
        attributes.zIndex = -numOfItems;
    }
    
    return attributes;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributesArray = [NSMutableArray array];
    NSInteger numOfSections = [self.collectionView numberOfSections];
    
    for (NSInteger section = 0; section < numOfSections; section++) {
        NSInteger numOfItem = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < numOfItem; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes* cellAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            if (CGRectIntersectsRect(rect, cellAttributes.frame)) {
                [attributesArray addObject:cellAttributes];
            }
        }
        
        NSIndexPath* sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes* titleAttirbutes = [self layoutAttributesForSupplementaryViewOfKind:StackLayoutElementKindTitle atIndexPath:sectionIndexPath];
        if (CGRectIntersectsRect(rect, titleAttirbutes.frame)) {
            [attributesArray addObject:titleAttirbutes];
        }
        
        UICollectionViewLayoutAttributes* decoAttributes = [self layoutAttributesForDecorationViewOfKind:[GradientView elementKind] atIndexPath:sectionIndexPath];
        if (CGRectIntersectsRect(rect, decoAttributes.frame)) {
            [attributesArray addObject:decoAttributes];
        }
    }
    
    return attributesArray;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}


- (void)setPinchPoint:(CGPoint)pinchPoint
{
    _pinchPoint = pinchPoint;
    [self invalidateLayout];
}

- (void)setPinchScale:(CGFloat)pinchScale
{
    _pinchScale = pinchScale;
    [self invalidateLayout];
}
@end
