//
//  LexikonAppDelegate.h
//  Lexikon
//
//  Created by Caleb Jaffa on 10/30/08.
//  Copyright 2008 Caleb Jaffa, MIT licensed
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "Word.h"

@interface LexikonAppDelegate : NSObject <UIApplicationDelegate> {
  IBOutlet UIWindow *window;
  IBOutlet UINavigationController *navigationController;
  IBOutlet UIBarButtonItem *languageSwitcherButton;
  NSMutableDictionary *currentWords;
  NSMutableDictionary *englishWords;
  NSMutableDictionary *swedishWords;
  BOOL swedishToEnglish;

  FMDatabase *database;  
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;

@property (nonatomic, retain) FMDatabase *database;


// Our word pointers, Eng and Swe contain the big lists and the current points to the current list
@property (nonatomic, retain) NSMutableDictionary *currentWords;
@property (nonatomic, retain) NSMutableDictionary *englishWords;
@property (nonatomic, retain) NSMutableDictionary *swedishWords;

@property (assign) BOOL swedishToEnglish;

- (BOOL)toggleSwedishToEnglish;
- (void)addWordToDictionary:(NSMutableDictionary *)words word:(Word *)word andDatabase:(BOOL) andDatabase;
- (void)removeWordAtSectionLetter:(NSString *) sectionLetter index:(NSUInteger) index;
@end

