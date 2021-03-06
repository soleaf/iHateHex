//
//  AppDelegate.h
//  iHateHex
//
//  Created by soleaf on 14. 1. 10..
//  Copyright (c) 2014년 soleaf. All rights reserved.
//  https://github.com/soleaf/iHateHex/
#import <Cocoa/Cocoa.h>
#import <BFPopoverColorWell.h>
#import "RetinaDropView.h"
#import "ColorPickerSampleView.h"
#import "ColorPickerImageView.h"

/*
 NSUserDefault Key
 For Setting Options
 */
static NSString* const DefaultUserKeyRetinaRevealInFinder = @"retina_reveal_in_finder";
static NSString* const DefaultUserKeySettingRetianReducerQual = @"setting_retina_reducer_qual";
static NSString* const DefaultUserKeySettingColorPickerAutoCopy = @"setting_colorpicker_autocopy";

@interface AppDelegate : NSObject  <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

// ScreenColorPicker
@property (unsafe_unretained) IBOutlet NSWindow *colorPickerCursorView;
@property (weak) IBOutlet ColorPickerSampleView *ui_colorPickerSampleView;
@property (weak) IBOutlet ColorPickerImageView *ui_colorPickerImageView;
@property (weak) IBOutlet NSImageView *ui_colorPickerGrid;

// TabView
@property (weak) IBOutlet NSTabView *tabView;

// HexTabContents
@property (weak) IBOutlet BFPopoverColorWell *ui_hexColPicker;
@property (weak) IBOutlet NSTextField *ui_hexHexField;
@property (weak) IBOutlet NSTextField *ui_hexUIColorField;
@property (weak) IBOutlet NSTextField *ui_hexNSColorField;

// RetinaReducerTabContents
@property (weak) IBOutlet RetinaDropView *ui_retinaReduceDropView;
@property (weak) IBOutlet NSTextField *ui_retinaReducerTip;
@property (weak) IBOutlet NSButton *ui_retinaReducerRevealInFinder;
@property (weak) IBOutlet NSProgressIndicator *ui_retinaReducerProgressbar;

// SettingTabContents
@property (weak) IBOutlet NSPopUpButton *ui_settingRetinaReducerQuality;
@property (weak) IBOutlet NSPopUpButton *ui_settingColorPickerAutocopy;


@end
