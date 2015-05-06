#<-dock->#
OSX Dock helper monitors mouse to provide auto repositioning to left/right on multi-monitor systems.

Objective-C and Swift sources available, build defaults to Swift executable (slightly more RAM usage, ~1MB, but according Apple could execute more quickly than comparable Obj-C code).

##requirements##
[XCode Command Line Tools](https://developer.apple.com/xcode/downloads/)

##installation##
1. Clone/fork the repo.
  ```shell
  > git clone https://github.com/ohnnyj/dock.git
  > cd dock
  ```

2. Build it.
  ```shell
  > make
  ```
####If you want to auto run on startup...####

3. Copy executable.
  ```shell
  > cp Build/Products/Release/\<-dock-\> /usr/local/bin/.
  ```

4. Copy daemon plist. (LaunchAgents -> per user, LaunchDaemons -> computer)  
  ```shell
  > cp com.ohnnyj.dock.plist /Library/LaunchAgents/com.ohnnyj.dock.plist
  ```

5. Add to launchctrl.  
  ```shell
  > launchctl load /Library/LaunchAgents/com.ohnnyj.dock.plist
  ```

**Note:** If you put the executable somewhere else (or rename it) you will need to modify the plist.
