//
//  NSTimer+GCD.h
//  XCode Strings
//
//  Created by Levy Xu on 2020/2/24.
//  Copyright © 2020 Kiwik. All rights reserved.
//

#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (GCD)

+(void)mainTask:(void(^)())block;

+(void)backgroundTask:(void(^)())block;

+(void)delay:(float)seconds task:(void(^)())block;

@end

NS_ASSUME_NONNULL_END
