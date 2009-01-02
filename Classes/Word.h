//
//  Word.h
//  Lexikon
//
//  Created by Caleb Jaffa on 11/13/08.
//  Copyright 2008-2009 Caleb Jaffa, MIT licensed
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

#define ENG_LANGUAGE 0
#define SWE_LANGUAGE 1

@interface Word : NSObject {
  NSString *word;
  int lang;
  NSString *translation;
  BOOL hydrated;
}

@property (nonatomic, retain) NSString *word;
@property (assign) int lang;
@property (readonly) NSString *letter;
@property (nonatomic, retain) NSString *translation;

// insert a new word with its translation
//+ (id)insertNewWordIntoDatabase:(NSString *) newWord language:(int) lang withTranslation:(NSString *) newTranslation database:(FMDatabase *)db;

// hydrate and dehydrate load and unload the translation into memory
- (void)hydrate;
- (void)dehydrate;

// remove the word from the database
//- (void)deleteFromDatabase;
- (NSString *)description;
- (NSComparisonResult)compare:(Word *)aWord;
- (BOOL)isEqual:(Word *)aWord;

@end
