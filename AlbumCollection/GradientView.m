//
//  GradientView.m
//  AlbumCollection
//
//  Created by Hiroki Yoshifuji on 2013/09/20.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(NSString*)elementKind {
    return @"ElementKindGradientDecoration";
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *color1 = [UIColor brownColor];
    UIColor *color2 = [UIColor lightGrayColor];
    
    CGColorRef colors[] = {color1.CGColor, color2.CGColor};
    CFArrayRef colorArray = CFArrayCreate(NULL,
                                          (const void**)colors,
                                          sizeof(colors)/sizeof(CGColorRef),
                                          &kCFTypeArrayCallBacks);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0f, 1.0f};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colorArray, locations);
    CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(rect.size.width, rect.size.height), 0);
    
    CFRelease(colorArray);
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

@end
