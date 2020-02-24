//
//  NSTimer+GCD.m
//  XCode Strings
//
//  Created by Levy Xu on 2020/2/24.
//  Copyright © 2020 Kiwik. All rights reserved.
//

#import "NSTimer+GCD.h"

#import <AppKit/AppKit.h>


@implementation NSTimer (GCD)

+(void)mainTask:(void(^)())block {
    dispatch_async(dispatch_get_main_queue(), block);
}

+(void)backgroundTask:(void(^)())block {
    dispatch_async(dispatch_get_global_queue(0, 0), block);
}

+(void)delay:(float)seconds task:(void(^)())block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

@end
