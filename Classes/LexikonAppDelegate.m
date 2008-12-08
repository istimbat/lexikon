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
  [self createEditableCopyOfDatabaseIfNeeded];
  [self initializeDatabase];
  [self initializeWords:self.englishWords language:ENG_LANGUAGE];
  [self initializeWords:self.swedishWords language:SWE_LANGUAGE];
  
  // default state of Swedish to English
  // TODO: change this to be saved via NSCoding to save state of the app
  self.swedishToEnglish = YES;
  self.currentWords = self.swedishWords; // point our current list to the Swedish words
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
  NSLog(@"MEMORY WARNING");
  for (NSString *letter in swedishWords) {
    [[swedishWords objectForKey:letter] makeObjectsPerformSelector:@selector(dehydrate)];
  }
  for (NSString *letter in englishWords) {
    [[englishWords objectForKey:letter] makeObjectsPerformSelector:@selector(dehydrate)];
  }
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
//    [self.database setTraceExecution: YES];
//    [self.database setLogsErrors: YES];    
  }
  else {
    NSAssert1(0, @"Could not open the database with message: %@", [self.database lastErrorMessage]);
  }
}

- (void)removeWordAtSectionLetter:(NSString *) sectionLetter index:(NSUInteger) index {
  NSMutableArray *wordsForSection = [currentWords objectForKey:sectionLetter];
  Word *myWord = [wordsForSection objectAtIndex:index];

  if ([database executeUpdate:@"DELETE FROM words WHERE word = ? AND lang = ?", myWord.word, [NSNumber numberWithInt:myWord.lang]]) {
    NSLog(@"Deleted word from database");
  }
  else {
    NSLog(@"unable to delete %@ from database", myWord);
  }
  
  [wordsForSection removeObjectAtIndex:index];
}

- (void)addWordToDictionary:(NSMutableDictionary *)words word:(Word *)newWord andDatabase:(BOOL) andDatabase {
  // get a pointer to the array for the letter this word belongs to
  NSMutableArray *wordsForLetter = [words objectForKey:newWord.letter];
  // if we don't have an array set yet, create it.
  if (wordsForLetter == nil) {
    // use this way so we can release this, the autorelease pool could get big
    NSMutableArray *newWordsForLetter = [[NSMutableArray alloc] initWithObjects: newWord, nil];
    
    // add the array to the Dictionary
    [words setObject:newWordsForLetter forKey:newWord.letter];
        
    [newWordsForLetter release];
  }
  else {
    // add the word to the array
    [wordsForLetter addObject:newWord];
  }

  if (andDatabase) {
    // if we are adding to the database we need to sort the array since we aren't pulling out of the database alphabetically
    [wordsForLetter sortUsingSelector:@selector(compare:)];
    newWord.word = [newWord.word capitalizedString];
    
    if ([database executeUpdate:@"REPLACE INTO words(word, lang, translation) VALUES(?, ?, ?)", [newWord.word capitalizedString], [NSNumber numberWithInt:newWord.lang], newWord.translation]) {
      NSLog(@"Added word to database too");
    }
    else {
      NSLog(@"Error adding word to database");
    }
  }
    
}

- (void)initializeWords:(NSMutableDictionary *)words language:(int)language {
  words = [[NSMutableDictionary alloc] init];  

  FMResultSet *rs = [database executeQuery:@"SELECT word FROM words WHERE lang = ? ORDER BY word", [NSNumber numberWithInt:language]];
  while ([rs next]) {
    Word *newWord = [[Word alloc] init];
    newWord.word = [rs stringForColumn:@"word"];
    newWord.lang = language;

    [self addWordToDictionary:words word:newWord andDatabase:NO];
    
    [newWord release];
  }
  // close the result set.
  [rs close];
  
  if (language == ENG_LANGUAGE) {
    self.englishWords = words;
  }
  else {
    self.swedishWords = words;
  }
  
  [words release];
}

@end