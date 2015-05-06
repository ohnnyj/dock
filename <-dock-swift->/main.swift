//
//  main.swift
//  dock-swift
//
//  Created by John Smith on 4/29/15.
//  Copyright (c) 2015 John Smith. All rights reserved.
//

import Foundation
import AppKit

var SOURCE =
"tell application \"System Events\"\n" +
  "tell dock preferences\n" +
  "set properties to {screen edge:%@}\n" +
  "end tell\n" +
"end tell\n";

class AppDelegate : NSObject, NSApplicationDelegate {
  var dock:NSAppleScript!
  var dockLeft:NSAppleScript!
  var dockRight:NSAppleScript!

  func applicationDidFinishLaunching(aNotification:NSNotification) {
    let screens = NSScreen.screens();

    if(screens?.count == 1) {
      println("Need more than one screen.");
      return;
    }

    self.dockLeft = NSAppleScript(source:String(format: SOURCE, "left"))
    self.dockRight = NSAppleScript(source:String(format: SOURCE, "right"))

    // assumptions, assumptions...
    let primary:AnyObject? = screens?.first;
    let secondary:AnyObject? = screens?.last;
    var left = primary!.frame.origin.x;
    var width = primary!.frame.size.width;

    if(secondary!.frame.origin.x < 0) {
      left = secondary!.frame.origin.x;
      width = secondary!.frame.size.width;
    }

    var handler = {
      [unowned self](event:NSEvent!) -> Void in
      let loc = NSEvent.mouseLocation()
      var script = self.dock

      if(loc.x >= left && loc.x < left + width) {
        script = self.dockLeft;
      } else {
        script = self.dockRight;
      }

      if(script != self.dock) {
        println("changing dock location")
        self.runScript(script)
        self.dock = script
      }
    }

    NSEvent.addGlobalMonitorForEventsMatchingMask(NSEventMask.MouseMovedMask, handler: handler);
  }

  func runScript(script:NSAppleScript!) {
    var error = AutoreleasingUnsafeMutablePointer<NSDictionary?>();

    script.executeAndReturnError(error);

    if(error != nil) {
      println(error);
    }
  }
}

let application = NSApplication.sharedApplication()
let delegate = AppDelegate()
application.delegate = delegate
application.run()