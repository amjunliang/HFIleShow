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
	// Insert code here to initialize your application

	self.barItem = [[ NSStatusBar systemStatusBar] statusItemWithLength:-2];
	self.barItem.button.image = [NSImage imageNamed:@"StatusBarButtonImage"];
	self.barItem.button.action = @selector(show:);

	NSMenu *menu = [NSMenu new];
	[menu addItem:[[NSMenuItem alloc]initWithTitle:@"	显示或隐藏文件(先执行隐藏)" action:@selector(show:) keyEquivalent:@""]];
	self.barItem.menu = menu;
	_menu = menu;

	self.isHidden = YES;

	//
	[menu addItem:[[NSMenuItem alloc]initWithTitle:@"	退出" action:@selector(quit) keyEquivalent:@""]];

}

- (void)quit
{
	[NSApp terminate:self];
}

- (void)show:(id) obj
{
	NSString *cmdStr = @"";
	if (_isHidden) {
		cmdStr = @"false";
		_menu.title = @"	显示隐藏文件";
		_isHidden = NO;
	}else{
		cmdStr = @"true";
		_menu.title = @"	显示隐藏文件";
		_isHidden = YES;
	}

		NSAppleScript *killfinder = [[NSAppleScript alloc] initWithSource:@"tell application \"Finder\" to quit"];
		[killfinder executeAndReturnError:nil];

		[[NSTask launchedTaskWithLaunchPath:@"/usr/bin/defaults"
								  arguments:@[@"write"
											  ,@"com.apple.finder"
											  ,@"AppleShowAllFiles"
											  ,[NSString stringWithFormat:@"%@",cmdStr]]] waitUntilExit];
	
	
		[[NSTask launchedTaskWithLaunchPath:@"/usr/bin/killall"
								  arguments:[NSArray arrayWithObjects:@"Finder", nil]] waitUntilExit];


}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}


@end
