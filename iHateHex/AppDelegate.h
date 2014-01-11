//
//  AppDelegate.h
//  iHateHex
//
//  Created by soleaf on 14. 1. 10..
//  Copyright (c) 2014년 soleaf. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <BFPopoverColorWell.h>

@interface AppDelegate : NSObject  <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

// Hex
@property (weak) IBOutlet BFPopoverColorWell *ui_hexColPicker;
@property (weak) IBOutlet NSTextField *ui_hexHexField;
@property (weak) IBOutlet NSTextField *ui_hexUIColorField;
@property (weak) IBOutlet NSTextField *ui_hexNSColorField;
@property (weak) IBOutlet NSTabView *tabView;

@end
