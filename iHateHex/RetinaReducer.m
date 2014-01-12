//
//  RetinaReducer.m
//  iHateHex
//
//  Created by soleaf on 1/12/14.
//  Copyright (c) 2014 soleaf. All rights reserved.
//

#import "RetinaReducer.h"

@implementation RetinaReducer

- (void) reduceFiles:(NSArray*)fileList andAfeterRevelInFinder:(BOOL) isRevealInFinder
{
    NSMutableString *errorLog = [[NSMutableString alloc] init];
    
    // Check Destination
    // TODO: destination folder was setted.
    NSString *destination = [self openDestinationDialog];
    if (!destination) return;
    
    
    // Check File Types
    //TODO: ..
    
    
    // Make NSImages
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (NSString *path in fileList) {
        
        @try {
            
            // Get
            NSImage *fullSizeImage = [[NSImage alloc] initWithContentsOfFile:path];
            NSString *filename = [path lastPathComponent];
            
            // Reduce
            CGSize newSize = [self sizeOfRetinaImageToReduce:fullSizeImage];
            NSImage *reducedImage = [self imageResize:fullSizeImage newSize:newSize];
            
            if (!fullSizeImage || !reducedImage){
                NSLog(@"----- >>>>>> No Image");
                continue;
            }
            
            [images addObject:@{@"fileName" : filename,
                                @"fullSizeImage" : fullSizeImage,
                                @"reducedImage" : reducedImage}];
            
        }
        @catch (NSException *exception) {
            
            NSLog(@"Err[Make NSImages] ------------> %@", exception.description);
            [errorLog appendString:@"\n"];
            [errorLog appendString:exception.description];
            
        }
        
    }
    
    
    // Save
    NSMutableArray *fileURLS = [[NSMutableArray alloc] init];
    for (NSDictionary *info in images) {
        
        @try {
            
            NSString *originFileName    = [info objectForKey:@"fileName"];
            NSImage *fullSizeImage      = [info objectForKey:@"fullSizeImage"];
            NSImage *reducedImage       = [info objectForKey:@"reducedImage"];
            
            originFileName              = [originFileName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
            originFileName              = [originFileName stringByReplacingOccurrencesOfString:@".png" withString:@""];
            
            NSString *fullSizeFileName  = [NSString stringWithFormat:@"%@@2x.png",originFileName];
            NSString *reducedFileName   = [NSString stringWithFormat:@"%@.png", originFileName];
            
            NSLog(@"origin file name:%@",fullSizeFileName);
            NSLog(@"reduced file name:%@",reducedFileName);
            
            NSString *fullSizePath      = [NSString stringWithFormat:@"%@/%@",destination, fullSizeFileName];
            NSString *reducedSizePath   = [NSString stringWithFormat:@"%@/%@",destination, reducedFileName];
            
            [self saveImage:fullSizeImage toFile:fullSizePath];
            [self saveImage:reducedImage toFile:reducedSizePath];
            
            NSURL *fullSizeFileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"file://%@",fullSizePath]];
            NSURL *reducedFileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"file://%@",reducedSizePath]];
            
            [fileURLS addObject:fullSizeFileURL];
            [fileURLS addObject:reducedFileURL];
            
        }
        @catch (NSException *exception) {
            
            NSLog(@"Err [Save] ------------> %@", exception.description);
            [errorLog appendString:@"\n"];
            [errorLog appendString:exception.description];
            
        }
        
    }
    
    if (errorLog.length > 0){
        NSAlert *alert = [[NSAlert alloc] init];
        
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"Error"];
        [alert setInformativeText:errorLog];
        [alert setAlertStyle:NSWarningAlertStyle];
    }
    
    
    // Reveal In Finder
    if (isRevealInFinder)
        [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:fileURLS];
    
    
    [[NSSound soundNamed:@"Pop"] play];
    
}


#pragma mark - File
- (NSString*) openDestinationDialog
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];
    
    // Enable the selection of directories in the dialog.
    [openDlg setCanChooseDirectories:YES];
    
    // Display the dialog.  If the OK button was pressed,
    // process the files.
    if ([openDlg runModal])
    {
        NSArray *files = [openDlg URLs];
        if (files.count > 0)
        {
            NSURL *fileURL = [files objectAtIndex:0];
            return fileURL.path;
        }
    }
    
    return nil;
}

- (void) saveImage:(NSImage*)image toFile:(NSString*)path
{
    NSData *imageData = [image TIFFRepresentation];
    NSBitmapImageRep *rep = [NSBitmapImageRep imageRepWithData:imageData];
    NSData *dataToWrite = [rep representationUsingType:NSPNGFileType
                                            properties:nil];
    [dataToWrite writeToFile:path atomically:NO];
}

#pragma mark - Handeling Image

- (NSSize) sizeOfRetinaImageToReduce:(NSImage*)image
{
    
    NSInteger height = image.size.height/2;
    NSInteger width  = image.size.width/2;
    
    NSLog(@"origin size : %lf %lf", image.size.width, image.size.height);
    NSLog(@"Resized : %ld %ld", width, height);

    return NSMakeSize(width, height);
}

- (NSImage *)imageResize:(NSImage*)anImage newSize:(NSSize)newSize
{
    NSImage *sourceImage = anImage;
    [sourceImage setScalesWhenResized:YES];
    
    // Report an error if the source isn't a valid image
    if (![sourceImage isValid])
    {
        NSLog(@"Invalid Image");
    } else
    {
        NSImage *smallImage = [[NSImage alloc] initWithSize: newSize];
        [smallImage lockFocus];
        [sourceImage setSize: newSize];
        [[NSGraphicsContext currentContext] setImageInterpolation:self.pngQuality];
        [sourceImage drawAtPoint:NSZeroPoint
                        fromRect:CGRectMake(0, 0, newSize.width, newSize.height)
                       operation:NSCompositeCopy fraction:1.0];
        [smallImage unlockFocus];
        return smallImage;
    }
    return nil;
}

@end
