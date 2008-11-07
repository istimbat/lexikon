//
//  LexikonAppDelegate.h
//  Lexikon
//
//  Created by Caleb Jaffa on 10/30/08.
//  Copyright 2008 Caleb Jaffa, MIT licensed
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface LexikonAppDelegate : NSObject <UIApplicationDelegate> {
  IBOutlet UIWindow *window;
  IBOutlet UINavigationController *navigationController;
  NSMutableArray *words;
  
  sqlite3 *database;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;

// Make the words available to other objects
@property (nonatomic, retain) NSMutableArray *words;

@end

