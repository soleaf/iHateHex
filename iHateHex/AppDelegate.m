//
//  AppDelegate.m
//  iHateHex
//
//  Created by soleaf on 14. 1. 10..
//  Copyright (c) 2014년 soleaf. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuPopUpViewController.h"
#import "AXStatusItemPopup.h"

@interface AppDelegate () {
    AXStatusItemPopup *_statusItemPopup;
}
@end

@implementation AppDelegate

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    MenuPopUpViewController *contentViewController = [[MenuPopUpViewController alloc] initWithNibName:@"MenuPopUpViewController" bundle:nil];
    
    // init the status item popup
    NSImage *image = [NSImage imageNamed:@"cloud"];
    NSImage *alternateImage = [NSImage imageNamed:@"cloudgrey"];
    
    _statusItemPopup = [[AXStatusItemPopup alloc] initWithViewController:contentViewController image:image alternateImage:alternateImage];
    
    // globally set animation state (optional, defaults to YES)
    //_statusItemPopup.animated = NO;
    
    //
    // --------------
    
    // optionally set the popover to the contentview to e.g. hide it from there
//    contentViewController.statusItemPopup = _statusItemPopup;

}
@end
