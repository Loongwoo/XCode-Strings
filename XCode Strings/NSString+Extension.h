//
//  NSString+Extension.h
//  StringManage
//
//  Created by kiwik on 1/20/16.
//  Copyright © 2016 Kiwik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface NSString(Extension)

-(BOOL)contain:(NSString*)str;

-(CGRect)sizeWithWidth:(CGFloat)width font:(NSFont*)font;

- (BOOL)isBlank;

- (NSString *) trim;

@end
