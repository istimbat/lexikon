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

@interface LexikonAppDelegate (Private)
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;
@end


@implementation LexikonAppDelegate

@synthesize window, navigationController, words, swedishToEnglish, numberOfLetters;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
//  [self createEditableCopyOfDatabaseIfNeeded];
//  [self initializeDatabase];

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
  self.numberOfLetters = NUMBER_ENGLISH_LETTERS;
  
  [window addSubview:navigationController.view];
  [window makeKeyAndVisible];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
  NSLog(@"MEMORY WARNING");
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


- (void)createEditableCopyOfDatabaseIfNeeded {
  // First, test for existence.
//  BOOL success;
//  NSFileManager *fileManager = [NSFileManager defaultManager];
//  NSError *error;
//  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//  NSString *documentsDirectory = [paths objectAtIndex:0];
//  NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"bookdb.sql"];
//  success = [fileManager fileExistsAtPath:writableDBPath];
//  if (success) return;
//  // The writable database does not exist, so copy the default to the appropriate location.
//  NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"database.sqlite3"];
//  success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
//  if (!success) {
//    NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
//  }
}

- (void)initializeDatabase {
//  NSMutableArray *bookArray = [[NSMutableArray alloc] init];
//  self.books = bookArray;
//  [bookArray release];
//  // The database is stored in the application bundle. 
//  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//  NSString *documentsDirectory = [paths objectAtIndex:0];
//  NSString *path = [documentsDirectory stringByAppendingPathComponent:@"database.sqlite3"];
//  // Open the database. The database was prepared outside the application.
//  if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
//    // Get the primary key for all books.
//    const char *sql = "SELECT pk FROM book";
//    sqlite3_stmt *statement;
//    // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
//    // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
//    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
//      // We "step" through the results - once for each row.
//      while (sqlite3_step(statement) == SQLITE_ROW) {
//        // The second parameter indicates the column index into the result set.
//        int primaryKey = sqlite3_column_int(statement, 0);
//        // We avoid the alloc-init-autorelease pattern here because we are in a tight loop and
//        // autorelease is slightly more expensive than release. This design choice has nothing to do with
//        // actual memory management - at the end of this block of code, all the book objects allocated
//        // here will be in memory regardless of whether we use autorelease or release, because they are
//        // retained by the books array.
//        Book *book = [[Book alloc] initWithPrimaryKey:primaryKey database:database];
//        [books addObject:book];
//        [book release];
//      }
//    }
//    // "Finalize" the statement - releases the resources associated with the statement.
//    sqlite3_finalize(statement);
//  } else {
//    // Even though the open failed, call close to properly clean up resources.
//    sqlite3_close(database);
//    NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
//    // Additional error handling, as appropriate...
//  }
}


@end
