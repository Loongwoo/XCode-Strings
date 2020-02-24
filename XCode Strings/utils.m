//
//  utils.m
//  XCode Strings
//
//  Created by Levy Xu on 2020/2/24.
//  Copyright © 2020 Kiwik. All rights reserved.
//

#import "utils.h"
#import "StringModel.h"

@implementation utils

+(void)exportXML:(NSString *)projectName stringArray:(NSArray *)stringArray {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    docPath = [docPath stringByAppendingPathComponent:[projectName stringByDeletingPathExtension]];
    BOOL isDirectory = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:docPath isDirectory:&isDirectory] || !isDirectory) {
        [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:kRegularExpressionPattern options:0 error:nil];
    
    for (StringModel *model in stringArray) {
        NSString *string = [NSString stringWithContentsOfFile:model.filePath usedEncoding:nil error:nil];
        
        NSMutableString *mutableString = [NSMutableString string];
        [string enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
            NSTextCheckingResult *result = [regularExpression firstMatchInString:line options:0 range:NSMakeRange(0, line.length)];
            if (result.range.location != NSNotFound && result.numberOfRanges == 5) {
                NSRange keyRange = [result rangeAtIndex:2];
                if (keyRange.location == NSNotFound)
                    keyRange = [result rangeAtIndex:3];
                
                NSRange valueRange = [result rangeAtIndex:4];
                
                NSString *key = [line substringWithRange:keyRange];
                NSString *value = [[[line substringWithRange:valueRange] stringByReplacingOccurrencesOfString:@"%@" withString:@"%s"] stringByReplacingOccurrencesOfString:@"%%" withString:@"%"];
                
                if (key && value) {
                    [mutableString appendFormat:@"<string name=\"%@\">%@</string>\n",key, value];
                }
            } else {
                [mutableString appendFormat:@"\n"];
            }
        }];
        
        NSString *fileName = [NSString stringWithFormat:@"strings-%@.xml",model.identifier];
        NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
        [mutableString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    [[NSWorkspace sharedWorkspace] openFile:docPath];
}

@end
