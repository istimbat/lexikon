//
//  LexikonAppDelegate.m
//  Lexikon
//
//  Created by Caleb Jaffa on 10/30/08.
//  Copyright 2008 Caleb Jaffa, MIT licensed
//

#import "LexikonAppDelegate.h"
#import "FMDatabase.h"

@class Word;

@interface LexikonAppDelegate (Private)
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;
- (void)initializeWords:(NSMutableDictionary *)words language:(int)language;
@end

@implementation LexikonAppDelegate

@synthesize window, navigationController, database, currentWords, englishWords, swedishWords, swedishToEnglish;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  [window addSubview:navigationController.view];
  [window makeKeyAndVisible];
}

- (void)awakeFromNib {
  NSLog(@"AWWAKE FROM NIB");  
  [self createEditableCopyOfDatabaseIfNeeded];
  [self initializeDatabase];
  [self initializeWords:self.englishWords language:ENG_LANGUAGE];
  [self initializeWords:self.swedishWords language:SWE_LANGUAGE];
  
  // default state of Swedish to English
  // TODO: change this to be saved via NSCoding to save state of the app
  self.swedishToEnglish = YES;
  self.currentWords = self.swedishWords; // point our current list to the Swedish words
  
  NSLog(@"DONE AWAKING");
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
  NSLog(@"MEMORY WARNING");
}

- (BOOL)toggleSwedishToEnglish {
  // toggle the language, point our current words to the right dictionary
  if (self.swedishToEnglish) {
    self.swedishToEnglish = NO;
    self.currentWords = self.englishWords;
  }
  else {
    self.swedishToEnglish = YES;
    self.currentWords = self.swedishWords;
  }
  return self.swedishToEnglish;
}


- (void)dealloc {
  [window release];
  [navigationController release];
  [currentWords release];
  [englishWords release];
  [swedishWords release];
  [super dealloc];
}


- (void)createEditableCopyOfDatabaseIfNeeded {
  NSLog(@"created editable copy of database");
  // this came from SQLite Books example app
  // First, test for existence.
  BOOL success;
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSError *error;
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"database.sqlite3"];
  success = [fileManager fileExistsAtPath:writableDBPath];
  if (success) return;
  // The writable database does not exist, so copy the default to the appropriate location.
  NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"database.sqlite3"];
  success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
  if (!success) {
    NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
  }
}

- (void)initializeDatabase {
  // setup access to the database
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *path = [documentsDirectory stringByAppendingPathComponent:@"database.sqlite3"];
  self.database = [FMDatabase databaseWithPath:path];
  if ([self.database open]) {
    [self.database setTraceExecution: YES];
    [self.database setLogsErrors: YES];    
  }
  else {
    NSAssert1(0, @"Could not open the database with message: %@", [self.database lastErrorMessage]);
  }
}

- (void)initializeWords:(NSMutableDictionary *)words language:(int)language {
  words = [[NSMutableDictionary alloc] init];  
NSLog(@"run query");
  NSLog(@"/database setup error? %d %d ", [self.database hadError], [self.database lastErrorCode]);
  NSLog(@"database error: %@", [self.database lastErrorMessage]);

  FMResultSet *rs = [database executeQuery:@"SELECT word FROM words WHERE lang = ? ORDER BY word", [NSNumber numberWithInt:language]];
NSLog(@"/run query");
  while ([rs next]) {
    Word *newWord = [[Word alloc] init];
    newWord.word = [rs stringForColumn:@"word"];
    NSLog(@"new Word for lang %d %@", language, [rs stringForColumn:@"word"]);
    // get a pointer to the array for the letter this word belongs to
    NSMutableArray *wordsForLetter = [words objectForKey:newWord.letter];
    // if we don't have an array set yet, create it.
    if (wordsForLetter == nil) {
      NSLog(@"creating new array");
      // use this way so we can release this, the autorelease pool could get big
      NSMutableArray *newWordsForLetter = [[NSMutableArray alloc] initWithObjects: newWord, nil];
      NSLog(@"size of new array %d", [newWordsForLetter count]);
      // add the array to the Dictionary
      [words setObject:newWordsForLetter forKey:newWord.letter];
      NSLog(@"letter: %@ for word: %@", newWord.letter, newWordsForLetter);
      [newWordsForLetter release];
    }
    else {
      // add the word to the array
      [wordsForLetter addObject:newWord];
      NSLog(@"array exists, adding new word size %d", [wordsForLetter count]);
    }
    [newWord release];
  }
  // close the result set.
  [rs close];
  
  if (language == 0) {
    self.englishWords = words;
  }
  else {
    self.swedishWords = words;
  }
  
  [words release];
}

@end
