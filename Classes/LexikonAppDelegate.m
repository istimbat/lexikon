//
//  LexikonAppDelegate.m
//  Lexikon
//
//  Created by Caleb Jaffa on 10/30/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
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
    [super dealloc];
}


@end
