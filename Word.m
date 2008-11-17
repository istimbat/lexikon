//
//  Word.m
//  Lexikon
//
//  Created by Caleb Jaffa on 11/13/08.
//  Copyright 2008 Caleb Jaffa, MIT licensed
//

#import "Word.h"


@implementation Word

@synthesize word, letter;

- (void)dealloc {
  [word release];
  [letter release];
  [translation release];
  [super dealloc];
}
@end
