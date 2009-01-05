//
//  LexikonAppDelegate.m
//  Lexikon
//
//  Created by Caleb Jaffa on 10/30/08.
//  Copyright 2008-2009 Caleb Jaffa, MIT licensed
//

#import "LexikonAppDelegate.h"
#import "MainViewController.h"
#import "FMDatabase.h"

@class Word;

@interface LexikonAppDelegate (Private)
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;
- (void)initializeWords:(NSMutableDictionary *)words language:(int)language;
@end

@implementation LexikonAppDelegate

@synthesize window, navigationController, database, currentWords, englishWords, swedishWords, swedishToEnglish, currentWord;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  [window addSubview:navigationController.view];
  [window makeKeyAndVisible];
}

- (void)awakeFromNib {
  [self createEditableCopyOfDatabaseIfNeeded];
  [self initializeDatabase];
  
  // Load the swedishToEnglish value, ! it and call toggleSwedishToEnglish to load the first word list
  self.swedishToEnglish = ! [[NSUserDefaults standardUserDefaults] boolForKey:@"swedishToEnglish"];
  [self toggleSwedishToEnglish];

  // if word != nil load it
  NSString *savedWord = [[NSUserDefaults standardUserDefaults] stringForKey:@"word"];
  if (savedWord != nil) {
    // send the user to the word they were looking at
    for (NSString *letter in currentWords) {
      for (Word *aWord in [currentWords objectForKey:letter]) {
        if ([aWord.word isEqual:savedWord]) {
          [(MainViewController*)navigationController.topViewController viewWord:aWord];          
        }
      }
    }
  }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// save user state
	[[NSUserDefaults standardUserDefaults] setBool:swedishToEnglish forKey:@"swedishToEnglish"];
  [[NSUserDefaults standardUserDefaults] setObject:currentWord forKey:@"word"];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
#ifdef DEBUG      
  NSLog(@"MEMORY WARNING");
#endif
  // dehydrate each word's translation from memory
  for (NSString *letter in swedishWords) {
    [[swedishWords objectForKey:letter] makeObjectsPerformSelector:@selector(dehydrate)];
  }
  for (NSString *letter in englishWords) {
    [[englishWords objectForKey:letter] makeObjectsPerformSelector:@selector(dehydrate)];
  }
  
  // unload the word list not in play
  if (self.swedishToEnglish) {
    self.englishWords = nil;
  }
  else {
    self.swedishWords = nil;
  }
}

- (BOOL)toggleSwedishToEnglish {
  // toggle the language, point our current words to the right dictionary
  if (self.swedishToEnglish) {
    self.swedishToEnglish = NO;
    if (self.englishWords == nil) {
      [self initializeWords:self.englishWords language:ENG_LANGUAGE];
    }
    self.currentWords = self.englishWords;
  }
  else {
    self.swedishToEnglish = YES;
    if (self.swedishWords == nil) {
      [self initializeWords:self.swedishWords language:SWE_LANGUAGE];
    }
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
  [currentWord release];
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
#ifdef DEBUG      
    NSLog(@"Deleted word from database");
    [database executeUpdate:@"VACUUM"]; // clean up the database
#endif
  }
  else {
#ifdef DEBUG      
    NSLog(@"unable to delete %@ from database", myWord);
#endif
  }
  
  [wordsForSection removeObjectAtIndex:index];
}

- (void)addWordToDictionary:(NSMutableDictionary *)words word:(Word *)newWord andDatabase:(BOOL) andDatabase {
#ifdef DEBUG      
  NSLog(@"in Add Word to Dictionary %d", andDatabase);
#endif
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
    NSUInteger index = [wordsForLetter indexOfObject:newWord];
    if (index == NSNotFound) {
      // add the word to the array
      [wordsForLetter addObject:newWord];
#ifdef DEBUG      
      NSLog(@"new Word");
#endif
    }
    else {
      // this word was already in the wordList, update the word object
      [[wordsForLetter objectAtIndex:index] setTranslation:newWord.translation];
#ifdef DEBUG      
      NSLog(@"update translation");
#endif
    }
  }
  
  if (andDatabase) {
    // if we are adding to the database we need to sort the array since we aren't pulling out of the database alphabetically
    [wordsForLetter sortUsingSelector:@selector(compare:)];
    newWord.word = [newWord.word capitalizedString];
    
    if ([database executeUpdate:@"REPLACE INTO words(word, lang, translation) VALUES(?, ?, ?)", [newWord.word capitalizedString], [NSNumber numberWithInt:newWord.lang], newWord.translation]) {
#ifdef DEBUG      
      NSLog(@"Added word to database too");
#endif
    }
    else {
#ifdef DEBUG      
      NSLog(@"Error adding word to database");
#endif
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