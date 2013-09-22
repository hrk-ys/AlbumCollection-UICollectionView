//
//  ThumbnailCell.h
//  AlbumCollection
//
//  Created by Hiroki Yoshifuji on 2013/09/19.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThumbnailCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

+(CGSize)sizeForImageSize:(CGSize)imageSize;

@end
