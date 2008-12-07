//
//  Word.m
//  Lexikon
//
//  Created by Caleb Jaffa on 11/13/08.
//  Copyright 2008 Caleb Jaffa, MIT licensed
//

#import "Word.h"
#import "LexikonAppDelegate.h"

@implementation Word

@synthesize word, lang, translation;

//+ (id)insertNewWordIntoDatabase:(NSString *) newWord language:(int) lang withTranslation:(NSString *) newTranslation database:(FMDatabase *)db {
// TODO: put in the database
  
//  [[self alloc] init];
//  
//  self.database = db;
//  self.word = newWord;
//  self.translation = newTranslation;
//  
//  return [self autorelease];
//}

//- (id)initWithWord:(NSString *) newWord {
//  self.word = newWord;
//}

- (NSString *)description {
  return word;
}

- (NSString *)letter {
  return [[word substringToIndex: 1] uppercaseString];
}

- (NSString *)translation {
  if(translation == nil) {
    // lazy load the translation
    [self hydrate];
  }  
  return translation;
}

- (void)hydrate {
  LexikonAppDelegate *appDelegate = (LexikonAppDelegate *)[[UIApplication sharedApplication] delegate];
  
  translation = [appDelegate.database stringForQuery:@"SELECT translation FROM words WHERE word = ? AND lang = ?", word, [NSNumber numberWithInt:lang]];
  
  hydrated = YES;
}

- (void)dehydrate {
  [translation release];
  
  hydrated = NO;
}

- (void)dealloc {
  [word release];
  [translation release];
  [super dealloc];
}
@end
