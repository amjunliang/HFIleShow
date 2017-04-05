//
//  AppDelegate.m
//  HFIleShow
//
//  Created by mjl on 2017/4/5.
//  Copyright © 2017年 mjl. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property NSStatusItem *barItem;
@property BOOL isHidden;
@property NSMenu *menu;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    
    //item
    self.barItem = [[ NSStatusBar systemStatusBar] statusItemWithLength:-2];
    self.barItem.button.image = [NSImage imageNamed:@"StatusBarButtonImage"];
    
    //menu
    NSMenu *menu = [NSMenu new];
    self.barItem.menu = menu;
    
    [menu addItem:[[NSMenuItem alloc]initWithTitle:@"  显示（隐藏文件）  " action:@selector(show) keyEquivalent:@""]];
    [menu addItem:[[NSMenuItem alloc]initWithTitle:@"  隐藏（隐藏文件）  " action:@selector(hidden) keyEquivalent:@""]];
    [menu addItem:[[NSMenuItem alloc]initWithTitle:@"  退出  " action:@selector(quit) keyEquivalent:@""]];
    
    
}
- (void)showFinder{
}
- (void)relaunchFinder
{
    [[NSTask launchedTaskWithLaunchPath:@"/usr/bin/killall"
                              arguments:[NSArray arrayWithObjects:@"Finder", nil]] waitUntilExit];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == @"QuitFinder")
    {
        if([keyPath isEqualToString:@"isTerminated"])
        {
            [[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.apple.finder" options:NSWorkspaceLaunchDefault additionalEventParamDescriptor:NULL launchIdentifier:NULL];
            [object removeObserver:self forKeyPath:@"isTerminated"];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)show
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[NSTask launchedTaskWithLaunchPath:@"/usr/bin/defaults"
                                  arguments:@[@"write"
                                              ,@"com.apple.finder"
                                              ,@"AppleShowAllFiles"
                                              ,@"TRUE"]] waitUntilExit];
        
        [self relaunchFinder];
    });

}
- (void)hidden
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[NSTask launchedTaskWithLaunchPath:@"/usr/bin/defaults"
                                  arguments:@[@"write"
                                              ,@"com.apple.finder"
                                              ,@"AppleShowAllFiles"
                                              ,@"FALSE"]] waitUntilExit];
        
        [self relaunchFinder];
    });
}

- (void)quit
{
    [NSApp terminate:self];
}

@end
