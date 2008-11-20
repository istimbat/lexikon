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

  [self changeIndexLetters: appDelegate.swedishToEnglish];
}

- (void)changeIndexLetters:(BOOL) swedish {
  // first time through set it up
  if(self.indexLetters == nil) {
    self.indexLetters = [NSMutableArray arrayWithObjects: @"{search}", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"Å", @"Ä", @"Ö", nil];
  }
  
  // TODO: once the refresh the index bug is fixed use this, but until then just display the Swedish alphabet language
//  if(true || swedish) {
//    [self.indexLetters addObject: @"Å"];
//    [self.indexLetters addObject: @"Ä"];
//    [self.indexLetters addObject: @"Ö"];
//  }
//  else {
//    [self.indexLetters removeObjectsInArray: [NSArray arrayWithObjects: @"Å", @"Ä", @"Ö", nil]];
//  }
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

  if(section == 0) {
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
  NSLog(@"# of sections %d", appDelegate.numberOfLetters+1);
  return appDelegate.numberOfLetters+1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  NSLog(@"indexTitlesForTableView");
  //NSLog(@"%@", self.indexLetters);
  return self.indexLetters;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  // return nil for the searchBar (1st section) and About (last section)
  if(section == 0) {
    return nil;
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
    mySearchBar.delegate = self;
    [cell.contentView addSubview:mySearchBar];
    [mySearchBar release];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"CAN EDIT ROW");
  if(indexPath.section == 0) {
    return NO;
  }
  else {
    return YES;
  }
}
#pragma mark TableView Delegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  return nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"editingStyle");
  if(indexPath.section == 0) {
    return UITableViewCellEditingStyleNone;
  }
  else {
    NSLog(@"editingStyle delete");
    return UITableViewCellEditingStyleDelete;
  }
}

#pragma mark UISearchBarDelegate

//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//	searchBar.showsCancelButton = YES;
//}
//
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
//	mySearchBar.showsCancelButton = NO;
//}
//
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//  [searchBar resignFirstResponder];
//  [searchBar.text = @"";
//}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [searchBar resignFirstResponder];
}

@end
