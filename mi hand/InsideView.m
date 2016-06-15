//
//  InsideView.m
//  mi
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "InsideView.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


@implementation InsideView

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2.画圆
    CGContextAddEllipseInRect(ctx, CGRectMake(30,30, SCREEN_WIDTH-((SCREEN_WIDTH - (SCREEN_HEIGHT*3.1/5-100))*0.5+25)*2 -10, SCREEN_WIDTH-((SCREEN_WIDTH - (SCREEN_HEIGHT*3.1/5-100))*0.5+25)*2 -10));
    
    CGContextSetLineWidth(ctx, 10);
    
    // 3.显示所绘制的东西
    CGContextStrokePath(ctx);
}


@end
