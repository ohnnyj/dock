//
//  main.m
//  dock
//
//  Created by John Smith on 4/29/15.
//  Copyright (c) 2015 John Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

NSString* SOURCE =
@"tell application \"System Events\"\n"
"tell dock preferences\n"
"set properties to {screen edge:%@}\n"
"end tell\n"
"end tell\n";

@interface AppDelegate : NSObject <NSApplicationDelegate>

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;

@property NSAppleScript* dock;
@property NSAppleScript* dockLeft;
@property NSAppleScript* dockRight;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  NSArray* screens = [NSScreen screens];

  if(screens.count == 1) {
    NSLog(@"Need more than one screen.");
    return;
  }

  self.dockLeft = [[NSAppleScript alloc] initWithSource:[NSString stringWithFormat:SOURCE, @"left"]];
  self.dockRight = [[NSAppleScript alloc] initWithSource:[NSString stringWithFormat:SOURCE, @"right"]];

  // assumptions, assumptions...
  NSScreen* primary = [screens objectAtIndex:0];
  NSScreen* secondary = [screens lastObject];
  NSInteger left = primary.frame.origin.x;
  NSInteger width = primary.frame.size.width;

  if(secondary.frame.origin.x < 0) {
    left = secondary.frame.origin.x;
    width = secondary.frame.size.width;
  }

  AppDelegate* __weak me = self;

  void (^handler)(NSEvent*) = ^(NSEvent *event){
    NSPoint loc = [NSEvent mouseLocation];
    NSAppleScript* script = me.dock;

    if(loc.x >= left && loc.x < left + width) {
      script = me.dockLeft;
    } else {
      script = me.dockRight;
    }

    if(script != me.dock) {
      NSLog(@"changing dock position");
      [me runScript:script];
      me.dock = script;
    }
  };

  [NSEvent addGlobalMonitorForEventsMatchingMask:NSMouseMovedMask
                                         handler:handler];
}

- (void)runScript:(NSAppleScript*)script {
  NSDictionary* error = nil;

  [script executeAndReturnError:&error];

  if(error != nil) {
    NSLog(@"%@", error);
  }
}

@end

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    AppDelegate *delegate = [[AppDelegate alloc] init];

    NSApplication * application = [NSApplication sharedApplication];
    [application setDelegate:delegate];
    [NSApp run];
  }
  return 0;
}
