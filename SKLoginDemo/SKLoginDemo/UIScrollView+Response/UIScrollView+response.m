//
//  UIScrollView+response.m
//  DemoChat
//
//  Created by AY on 2017/7/5.
//  Copyright © 2017年 AlexanderYeah. All rights reserved.
//

#import "UIScrollView+response.h"

@implementation UIScrollView (response)

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event

{
    
    //处理scrollView
    NSLog(@"Alex");
    
    
    //传递出去
    
    [[self nextResponder] touchesBegan:touches withEvent:event];
    
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event

{
    
    //处理scrollView
    
    
    
    //传递出去
    
    [[self nextResponder] touchesMoved:touches withEvent:event];
    
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event

{
    
    //处理scrollView
    
    
    
    //传递出去
    
    [[self nextResponder] touchesEnded:touches withEvent:event];
    
}

@end
