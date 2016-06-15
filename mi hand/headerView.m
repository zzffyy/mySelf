//
//  headerView.m
//  mi
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "headerView.h"
#import "UIView+Extension.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


@implementation headerView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2.画圆
    CGContextAddEllipseInRect(ctx, CGRectMake(5,5,(([UIScreen mainScreen].bounds.size.height*3.1/5-100)-10), ([UIScreen mainScreen].bounds.size.height*3.1/5-100)-10));
    
    CGContextSetLineWidth(ctx, 1);
    
        CGContextStrokePath(ctx);
    

    
}




@end
