/*
 * Copyright 2008-2011, Torsten Curdt
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Cocoa/Cocoa.h>
#import "FRUploader.h"

#define FR_FEEDBACK  @"feedback"
#define FR_EXCEPTION @"exception"
#define FR_CRASH     @"crash"

@interface FRFeedbackController : NSWindowController 
#if MAC_OS_X_VERSION_MAX_ALLOWED >= 1060 // on lines like this to not confuse IB
<FRUploaderDelegate, NSWindowDelegate>
#else
<FRUploaderDelegate>
#endif
{
@private
    IBOutlet NSTextField *headingField;
    IBOutlet NSTextField *subheadingField;

    IBOutlet NSTextField *messageLabel;
    IBOutlet NSTextView *messageView;

    IBOutlet NSTextField *emailLabel;
    IBOutlet NSComboBox *emailBox;

    IBOutlet NSButton *detailsButton;
    IBOutlet NSTextField *detailsLabel;
    BOOL detailsShown;

	IBOutlet NSButton *sendDetailsCheckbox;

    IBOutlet NSTabView *tabView;
    IBOutlet NSTabViewItem *tabSystem;
    IBOutlet NSTabViewItem *tabConsole;
    IBOutlet NSTabViewItem *tabCrash;
    IBOutlet NSTabViewItem *tabScript;
    IBOutlet NSTabViewItem *tabPreferences;
    IBOutlet NSTabViewItem *tabException;

    IBOutlet NSTableView *systemView;
    IBOutlet NSTextView *consoleView;
    IBOutlet NSTextView *crashesView;
    IBOutlet NSTextView *scriptView;
    IBOutlet NSTextView *preferencesView;
    IBOutlet NSTextView *exceptionView;

    IBOutlet NSProgressIndicator *indicator;
    IBOutlet NSTextField *indicatorDetail;

    IBOutlet NSButton *cancelButton;
    IBOutlet NSButton *sendButton;
    
    FRUploader *uploader;
    
    id delegate;
    
    NSString *type;
}

@property (nonatomic, assign)IBOutlet  NSTextField*headingField;
@property (nonatomic, assign)IBOutlet  NSTextField*subheadingField;
@property (nonatomic, assign)IBOutlet  NSTextField*messageLabel;
@property (nonatomic, assign)IBOutlet  NSTextView*messageView;
@property (nonatomic, assign)IBOutlet  NSTextField*emailLabel;
@property (nonatomic, assign)IBOutlet  NSComboBox*emailBox;
@property (nonatomic, assign)IBOutlet  NSButton*detailsButton;
@property (nonatomic, assign)IBOutlet  NSTextField*detailsLabel;
@property (nonatomic, assign)IBOutlet  NSButton*sendDetailsCheckbox;
@property (nonatomic, assign)IBOutlet  NSTabView*tabView;
@property (nonatomic, assign)IBOutlet  NSTabViewItem*tabSystem;
@property (nonatomic, assign)IBOutlet  NSTabViewItem*tabConsole;
@property (nonatomic, assign)IBOutlet  NSTabViewItem*tabCrash;
@property (nonatomic, assign)IBOutlet  NSTabViewItem*tabScript;
@property (nonatomic, assign)IBOutlet  NSTabViewItem*tabPreferences;
@property (nonatomic, assign)IBOutlet  NSTabViewItem*tabException;
@property (nonatomic, assign)IBOutlet  NSTableView*systemView;
@property (nonatomic, assign)IBOutlet  NSTextView*consoleView;
@property (nonatomic, assign)IBOutlet  NSTextView*crashesView;
@property (nonatomic, assign)IBOutlet  NSTextView*scriptView;
@property (nonatomic, assign)IBOutlet  NSTextView*preferencesView;
@property (nonatomic, assign)IBOutlet  NSTextView*exceptionView;
@property (nonatomic, assign)IBOutlet  NSProgressIndicator*indicator;
@property (nonatomic, assign)IBOutlet  NSTextField*indicatorDetail;
@property (nonatomic, assign)IBOutlet  NSButton*cancelButton;
@property (nonatomic, assign)IBOutlet  NSButton*sendButton;

#pragma mark Accessors

- (id) delegate;
- (void) setDelegate:(id) delegate;

- (void) setHeading:(NSString*)message;
- (void) setSubheading:(NSString *)informativeText;
- (void) setMessage:(NSString*)message;
- (void) setException:(NSString*)exception;
- (void) setType:(NSString*)type;

#pragma mark UI

- (IBAction) showDetails:(id)sender;
- (IBAction) cancel:(id)sender;
- (IBAction) send:(id)sender;

#pragma mark Other

- (void) reset;
- (BOOL) isShown;

@end
