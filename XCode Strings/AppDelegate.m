//
//  AppDelegate.m
//  XCode Strings
//
//  Created by kiwik on 16/12/1.
//  Copyright © 2016年 Kiwik. All rights reserved.
//

#import "AppDelegate.h"
#import "StringWindowController.h"
#import "StringModel.h"
#import "NSMutableArray+LSCore.h"

#define kRecentFilePath [StringModel recentFilePath]

@interface AppDelegate () <NSMenuDelegate>
@property (nonatomic, strong) StringWindowController* windowController;
@property (nonatomic, strong) NSMutableArray *pathArray;
@property (weak) IBOutlet NSMenu *clearMenu;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.pathArray = [NSMutableArray arrayWithArray:[self readRecent]];
    self.clearMenu.delegate = self;
}

- (void)applicationDidBecomeActive:(NSNotification *)notification{
    [self openOrReopen];
}

-(BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    [self openOrReopen];
    return YES;
}

-(void)openOrReopen {
    if (self.pathArray.count == 0) {
        [self openDoc:nil];
    }
    else {
        if (! self.windowController.window.isVisible) {
            [self openTheFirstPath];
        }
    }
}

#pragma mark - Button Actions
- (IBAction)openDoc:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setMessage:NSLocalizedString(@"SelectProjectFile", nil)];
    [panel setPrompt:NSLocalizedString(@"OK", nil)];
    [panel setCanChooseDirectories:NO];
    [panel setCanCreateDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowedFileTypes:@[@"xcodeproj",@"xcworkspace"]];
    if ([panel runModal] == NSFileHandlingPanelOKButton) {
        NSString *path = [[panel URL] path];
        if ([self.pathArray containsObject:path]) {
            [self.pathArray removeObject:path];
        }
        if (self.pathArray.count == 10) {
            [self.pathArray removeLastObject];
        }
        [self.pathArray insertObject:path atIndex:0];
        [self saveRecent];
        [self openTheFirstPath];
    }
}

-(void)openTheFirstPath {
    
    NSAssert(self.pathArray.count > 0, @"pathArray should not be null.");
    
    if (self.windowController == nil) {
        self.windowController = [[StringWindowController alloc] init];
    }
    NSString *path = self.pathArray[0];
    NSString* projectDir = [path stringByDeletingLastPathComponent];
    NSString *projectName = [path lastPathComponent];
    [self.windowController.window makeKeyAndOrderFront:nil];
    [self.windowController setSearchRootDir:projectDir projectName:projectName];
    [self.windowController refresh:nil];
}


- (IBAction)prefAction:(id)sender {
    if ([self.windowController.window isVisible]) {
        [self.windowController showPreferencesPanel:nil];
    }
}

- (IBAction)showHelp:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/Loongwoo/XCodeStrings"]];
}

#pragma mark - NSMenuDelegate
- (void)menuWillOpen:(NSMenu *)menu {
    
    [menu removeAllItems];
    
    for (int i=0; i<self.pathArray.count; i++) {
        NSString *path = self.pathArray[i];
        NSString *projectName = [path lastPathComponent];
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:projectName action:@selector(itemClicked:) keyEquivalent:@""];
        item.tag = 100 + i;
        [menu addItem:item];
    }
    [menu addItem:[NSMenuItem separatorItem]];
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"ClearRecords", nil) action:@selector(clearClicked:) keyEquivalent:@""];
    [menu addItem:item];
}

-(void)itemClicked:(NSMenuItem *)item {
    [self.pathArray moveObjectAtIndex:item.tag-100 toIndex:0];
    [self saveRecent];
    [self openTheFirstPath];
}

-(void)clearClicked:(NSMenuItem *)item {
    [self.pathArray removeObjectsInRange:NSMakeRange(1, self.pathArray.count-1)];
    [self saveRecent];
}

#pragma mark - File
-(NSArray *)readRecent {
    if([[NSFileManager defaultManager] fileExistsAtPath:kRecentFilePath]){
        NSArray *array = nil;
        @try {
            array = [NSKeyedUnarchiver unarchiveObjectWithFile:kRecentFilePath];
            
        }
        @catch (NSException* exception) {
            NSLog(@"读取失败 exception %@",exception);
        }
        return array;
    }
    return nil;
}

-(void)saveRecent {
    @try {
        [NSKeyedArchiver archiveRootObject:self.pathArray toFile:kRecentFilePath];
    }
    @catch (NSException* exception) {
        NSLog(@"saveProjectSetting:exception:%@", exception);
    }
}
@end
