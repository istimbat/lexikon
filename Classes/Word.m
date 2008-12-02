//
//  Word.m
//  Lexikon
//
//  Created by Caleb Jaffa on 11/13/08.
//  Copyright 2008 Caleb Jaffa, MIT licensed
//

#import "Word.h"

@implementation Word

@synthesize word;

+ (id)insertNewWordIntoDatabase:(NSString *) newWord withTranslation:(NSString *) newTranslation database:(FMDatabase *)db {
  // TODO: put in the database
  
//  [[self alloc] init];
//  
//  self.database = db;
//  self.word = newWord;
//  self.translation = newTranslation;
//  
  return [self autorelease];
}

//- (id)initWithWord:(NSString *) newWord {
//  self.word = newWord;
//}


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

- (NSString *)description {
  return self.word;
}

- (void)hydrate {
  // TODO: load the translation from the database
  [[translation alloc] initWithString: @"TODO make this come from the database"];
  
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
