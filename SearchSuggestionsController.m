//
//  SearchSuggestionsController.m
//  Lexikon
//
//  Created by Caleb Jaffa on 2/8/09.
//  Copyright 2008-2009 Caleb Jaffa, MIT licensed
//

#import "SearchSuggestionsController.h"
#import "Word.h"
#import "MainViewController.h"

@implementation SearchSuggestionsController

@synthesize tableView, suggestions, main;

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
  // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [suggestions count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  static NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
  }
  
  cell.text = [[suggestions objectAtIndex:indexPath.row] word];
    
  // Set up the cell...

  return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [main viewWord:[suggestions objectAtIndex:indexPath.row]];
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)dealloc {
  [main release];
  [suggestions release];
  [tableView release];
  [super dealloc];
}


@end

