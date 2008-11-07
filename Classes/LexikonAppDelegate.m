//
//  LexikonAppDelegate.m
//  Lexikon
//
//  Created by Caleb Jaffa on 10/30/08.
//  Copyright 2008 Caleb Jaffa, MIT licensed
//

#import "LexikonAppDelegate.h"

@implementation LexikonAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
  [window release];
  [navigationController release];
  [words release];
  [super dealloc];
}


@end
