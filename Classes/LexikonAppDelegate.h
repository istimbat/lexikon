//
//  LexikonAppDelegate.h
//  Lexikon
//
//  Created by Caleb Jaffa on 10/30/08.
//  Copyright 2008 Caleb Jaffa, MIT licensed
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

#define NUMBER_ENGLISH_LETTERS 26
#define NUMBER_SWEDISH_LETTERS 29

@interface LexikonAppDelegate : NSObject <UIApplicationDelegate> {
  IBOutlet UIWindow *window;
  IBOutlet UINavigationController *navigationController;
  IBOutlet UIBarButtonItem *languageSwitcherButton;
  NSMutableArray *words;
  BOOL swedishToEnglish;
  NSInteger numberOfLetters;
  
  sqlite3 *database;
  
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;

// Make the words available to other objects
@property (nonatomic, retain) NSMutableArray *words;

@property (assign) NSInteger numberOfLetters;
@property (assign) BOOL swedishToEnglish;

- (BOOL)toggleSwedishToEnglish;

@end

