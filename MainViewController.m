//
//  MainViewController.m
//  Lexikon
//
//  Created by Caleb Jaffa
//  Copyright 2008 Caleb Jaffa, MIT licensed
//

#import "MainViewController.h"
#import "Word.h"
#import "LexikonAppDelegate.h"

@implementation MainViewController

@synthesize tableView, indexLetters;

- (void)awakeFromNib {
  // we need to get at properties of our application delegate
  LexikonAppDelegate *appDelegate = (LexikonAppDelegate *)[[UIApplication sharedApplication] delegate];
  
  // make it so the index is always displayed
  tableView.sectionIndexMinimumDisplayRowCount = 1;
  
  // TODO: figure out how to exclude the searchBar and About cell from being editted
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  [self changeIndexLetters: appDelegate.swedishToEnglish];
}

- (void)changeIndexLetters:(BOOL) swedish {
  // first time through set it up
  if(self.indexLetters == nil) {
    self.indexLetters = [NSMutableArray arrayWithObjects: @"{search}", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"•", nil];
  }
  
  if(swedish) {
    // do this in inverse order to insert them with a constant
    [self.indexLetters insertObject: @"Ö" atIndex: NUMBER_ENGLISH_LETTERS+1];
    [self.indexLetters insertObject: @"Ä" atIndex: NUMBER_ENGLISH_LETTERS+1];
    [self.indexLetters insertObject: @"Å" atIndex: NUMBER_ENGLISH_LETTERS+1];
  }
  else {
    [self.indexLetters removeObjectsInArray: [NSArray arrayWithObjects: @"Å", @"Ä", @"Ö", nil]];
  }
}

- (IBAction)switchLanguage:(id)sender {
  LexikonAppDelegate *appDelegate = (LexikonAppDelegate *)[[UIApplication sharedApplication] delegate];

  BOOL swedish = [appDelegate toggleSwedishToEnglish];
  
  if(swedish) {
    //TODO: what do we need to change to make things Swedish?
    languageSwitcherButton.title = @"Swe to Eng";
  }
  else {
    // TODO: toggled to English change things
    languageSwitcherButton.title = @"Eng to Swe";
  }
  
  [self changeIndexLetters: swedish];
  
  NSLog(@"RELOAD DATA");
  [self.tableView reloadData];
  NSLog(@"/RELOAD DATA");
  
}


#pragma mark TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // we need to get at properties in our app delegate
  LexikonAppDelegate *appDelegate = (LexikonAppDelegate *)[[UIApplication sharedApplication] delegate];

  if(section == 0 || section == appDelegate.numberOfLetters+1) {
   return 1; // return 1 for section 0 and MAX all other will be dynamic 
  }
  else {
    if(section == 1) {
      NSLog(@"ROWS: %i", appDelegate.words.count);
      return appDelegate.words.count;        
    }
    else {
      return 0;
    }
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // the number of sections is the number of letters + 2 (searchBar and About)
  LexikonAppDelegate *appDelegate = (LexikonAppDelegate *)[[UIApplication sharedApplication] delegate];
  NSLog(@"# of sections %d", appDelegate.numberOfLetters+2);
  return appDelegate.numberOfLetters+2;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  NSLog(@"indexTitlesForTableView");
  //NSLog(@"%@", self.indexLetters);
  return self.indexLetters;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
  NSLog(@"sectionForSectionIndexTitle %@ %d", title, index);
  return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  LexikonAppDelegate *appDelegate = (LexikonAppDelegate *)[[UIApplication sharedApplication] delegate];

  // return nil for the searchBar (1st section) and About (last section)
  if(section == 0) {
    return nil;
  }
  else if (section == appDelegate.numberOfLetters+1) {
    return @"";
  }
  else {
    // TODO: if there are no words return a blank string so the section header doesn't show
    if(section == 1) {
      return [self.indexLetters objectAtIndex:section];
    }
    else {
      return @"";
    }
  }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  LexikonAppDelegate *appDelegate = (LexikonAppDelegate *)[[UIApplication sharedApplication] delegate];
  
  // searchBar cell gets its own identifier
  NSString *identifier = (indexPath.section == 0) ? @"search" : @"cell";
  
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
  if(cell == nil) {
    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];    
  }

  //NSLog(@"Row: %i,%i ID: %@", indexPath.section, indexPath.row, identifier);
  if(indexPath.section == 0) {
    // TODO: navigation bar or image to fill in the gap so our seach bar can be 293 pixels and not over the index
    UINavigationBar *myNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    [myNavigationBar setTintColor: [UIColor colorWithRed:0.769 green:0.80 blue:0.824 alpha:1.0]];
    [myNavigationBar sizeToFit];
    [cell.contentView addSubview:myNavigationBar];
    [myNavigationBar release];
    
    // Now add our search bar
    UISearchBar *mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    [mySearchBar setTintColor: [UIColor colorWithRed:0.769 green:0.80 blue:0.824 alpha:1.0]];
    [mySearchBar sizeToFit];
    CGRect myRect = mySearchBar.frame;
    myRect.size.width = 293;
    mySearchBar.frame = myRect;
    mySearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [cell.contentView addSubview:mySearchBar];
    [mySearchBar release];
  }
  else if(indexPath.section == appDelegate.numberOfLetters+1) {
    cell.text = @"About";
  }
  else {
    NSLog(@"row %i %@", indexPath.row, [[appDelegate.words objectAtIndex:indexPath.row] word]);
    if(appDelegate.swedishToEnglish) {
      cell.text = [[appDelegate.words objectAtIndex:indexPath.row] word];      
    }
    else {
      cell.text = @"123";
    }
  }
  
  return cell;
}



// TODO: figure out how to leave out the searchBar and About cells
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  // Updates the appearance of the Edit|Done button as necessary.
  [super setEditing:editing animated:animated];
  [self.tableView setEditing:editing animated:YES];
}  

#pragma mark TableView Delegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  return nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  // TODO: should we retain this pointer or grab it all the time, what's better memory vs. speed?
  LexikonAppDelegate *appDelegate = (LexikonAppDelegate *)[[UIApplication sharedApplication] delegate];

  // TODO: change section 2 to MAX of our sections
  if(indexPath.section == 0 || indexPath.section == appDelegate.numberOfLetters) {
    return UITableViewCellEditingStyleNone;
  }
  else {
    return UITableViewCellEditingStyleDelete;
  }
}


@end
