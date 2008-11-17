//
//  Word.h
//  Lexikon
//
//  Created by Caleb Jaffa on 11/13/08.
//  Copyright 2008 Caleb Jaffa, MIT licensed
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Word : NSObject {
  sqlite3 *database;
  NSString *word;
  NSString *letter;
  NSString *translation;
  BOOL hydrated;
}

@property (copy, nonatomic) NSString *word;
@property (copy, nonatomic) NSString *letter;
@property (copy, nonatomic) NSString *translation;

// insert a new word with its translation
//+ (BOOL)insertNewWordIntoDatabase:(sqlite3 *)db;

// hydrate and dehydrate load and unload the translation into memory
//- (void)hydrate;
//- (void)dehydrate;

// remove the word from the database
//- (void)deleteFromDatabase;

@end
