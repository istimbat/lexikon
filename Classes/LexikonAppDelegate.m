//
//  LexikonAppDelegate.m
//  Lexikon
//
//  Created by Caleb Jaffa on 10/30/08.
//  Copyright 2008 Caleb Jaffa, MIT licensed
//

#import "LexikonAppDelegate.h"
#import "Word.h"

@class Word;

@implementation LexikonAppDelegate

@synthesize window, navigationController, words, swedishToEnglish, numberOfLetters;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
  [window addSubview:navigationController.view];

  // default state of Swedish to English
  // TODO: change this to be saved via NSCoding to save state of the app
  self.swedishToEnglish = YES;
  
  // create some hardcoded words for now
  Word *one = [[Word alloc] init];
  one.word = @"Apple";
  one.letter = @"A";
  
  Word *two = [[Word alloc] init];
  two.word = @"Art";
  two.letter = @"A";
  
  self.words = [NSMutableArray arrayWithObjects: one, two, nil];
  
  [one release];
  [two release];
  
  // Override point for customization after application launch
  [window makeKeyAndVisible];
}


- (BOOL)toggleSwedishToEnglish {
  if (self.swedishToEnglish) {
    self.numberOfLetters = NUMBER_ENGLISH_LETTERS;
    self.swedishToEnglish = NO;
  }
  else {
    self.numberOfLetters = NUMBER_SWEDISH_LETTERS;
    self.swedishToEnglish = YES;    
  }
  return self.swedishToEnglish;
}


- (void)dealloc {
  [window release];
  [navigationController release];
  [words release];
  [super dealloc];
}


@end
