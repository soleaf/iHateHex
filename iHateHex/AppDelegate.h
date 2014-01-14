//
//  AppDelegate.h
//  iHateHex
//
//  Created by soleaf on 14. 1. 10..
//  Copyright (c) 2014년 soleaf. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <BFPopoverColorWell.h>
#import "RetinaDropView.h"

static NSString* const DefaultUserKeyRetinaRevealInFinder = @"retina_reveal_in_finder";
static NSString* const DefaultUserKeySettingRetianReducerQual = @"setting_retina_reducer_qual";
static NSString* const DefaultUserKeySettingColorPickerAutoCopy = @"setting_colorpicker_autocopy";

@interface AppDelegate : NSObject  <NSApplicationDelegate>


@property (assign) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSWindow *colorPickerCursorView;
@property (weak) IBOutlet NSColorWell *ui_colorPickerCursorColor;

// Hex
@property (weak) IBOutlet BFPopoverColorWell *ui_hexColPicker;
@property (weak) IBOutlet NSTextField *ui_hexHexField;
@property (weak) IBOutlet NSTextField *ui_hexUIColorField;
@property (weak) IBOutlet NSTextField *ui_hexNSColorField;
@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet RetinaDropView *ui_retinaReduceDropView;
@property (weak) IBOutlet NSTextField *ui_retinaReducerTip;
@property (weak) IBOutlet NSButton *ui_retinaReducerRevealInFinder;
@property (weak) IBOutlet NSProgressIndicator *ui_retinaReducerProgressbar;
@property (weak) IBOutlet NSPopUpButton *ui_settingRetinaReducerQuality;
@property (weak) IBOutlet NSPopUpButton *ui_settingColorPickerAutocopy;
@property (weak) IBOutlet NSImageView *ui_colorPickerImageView;


@end
