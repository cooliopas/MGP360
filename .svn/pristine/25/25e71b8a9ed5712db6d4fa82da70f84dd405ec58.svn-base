//
//  UIViewController+Orientation.m
//  TruantVr360
//
//  Created by fede on 4/16/15.
//  Copyright (c) 2015 lateralview. All rights reserved.
//

#import "UIViewController+Orientation.h"
#import <objc/runtime.h>

static NSUInteger __orientation = UIInterfaceOrientationMaskAll;

@implementation UIViewController (Orientation)

+ (void)load
{
    Method original, swizzled;
    original = class_getInstanceMethod(self, @selector(viewWillDisappear:));
    swizzled = class_getInstanceMethod(self, @selector(swizzled_viewWillDisappear:));
    method_exchangeImplementations(original, swizzled);
}

- (void)swizzled_viewWillDisappear:(BOOL)animated
{
    __orientation = UIInterfaceOrientationMaskAll;
    [self swizzled_viewWillDisappear:animated];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return __orientation;
}

- (void)setOrientation:(NSUInteger)orientation
{
    __orientation = orientation;
}

@end