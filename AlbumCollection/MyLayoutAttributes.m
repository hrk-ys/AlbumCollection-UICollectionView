//
//  MyLayoutAttributes.m
//  AlbumCollection
//
//  Created by Hiroki Yoshifuji on 2013/09/20.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "MyLayoutAttributes.h"

@implementation MyLayoutAttributes

- (id)copyWithZone:(NSZone *)zone
{
    MyLayoutAttributes* attributes = (MyLayoutAttributes*)[super copyWithZone:zone];
    attributes.shadowOpacity = self.shadowOpacity;
    attributes.headerTextAlignment = self.headerTextAlignment;
    return attributes;
}

@end
