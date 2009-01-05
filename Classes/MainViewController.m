//
//  MainViewController.m
//  Lexikon
//
//  Created by Caleb Jaffa
//  Copyright 2008-2009 Caleb Jaffa, MIT licensed
//

#import "MainViewController.h"
#import "Word.h"
#import "LexikonAppDelegate.h"
#import "DetailViewController.h"
#import "AboutViewController.h"

@implementation MainViewController

@synthesize tableView, indexLetters, mySearchBar;

- (void)awakeFromNib {
  // we need to get at properties of our application delegate
  LexikonAppDelegate *appDelegate = (LexikonAppDelegate *)[[UIApplication sharedApplication] delegate];
  
  // make it so the index is always displayed
  tableView.sectionIndexMinimumDisplayRowCount = 1;
  [self changeIndexLetters: appDelegate.swedishToEnglish];
  
  searching = NO; // keep track if we are in the middle of a search or not
}

- (void)dealloc {
  NSLog(@"dealloc");
  [mySearchBar release];
  [detailViewController release];
  [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
  [self.tableView reloadData];

  // update the app delegate that we are no longer viewing a specific word
  LexikonAppDelegate *appDelegate = (LexikonAppDelegate *)[[UIApplication sharedApplication] delegate];
  appDelegate.currentWord = nil;
}

- (void)changeIndexLetters:(BOOL) swedish {
  // first time through set it up
  if(self.indexLetters == nil) {
    self.indexLetters = [NSMutableArray arrayWithObjects: @"{search}", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
  }
  
  if(swedish) {
    [self.indexLetters addObject: @"Å"];
    [self.indexLetters addObject: @"Ä"];
    [self.indexLetters addObject: @"Ö"];
    languageSwitcherButton.title = @"Swe to Eng";
  }
  else {
    [self.indexLetters removeObjectsInArray: [NSArray arrayWithObjects: @"Å", @"Ä", @"Ö", nil]];
    languageSwitcherButton.title = @"Eng to Swe";
  }
}

- (IBAction)switchLanguage:(id)sender {
  LexikonAppDelegate *appDelegate = (LexikonAppDelegate *)[[UIApplication sharedApplication] delegate];
  
  BOOL swedish = [appDelegate toggleSwedishToEnglish];
    
  [self changeIndexLetters: swedish];
  
  [self.tableView reloadData];    
}

- (IBAction)showAbout:(id)sender {
  AboutViewController *aboutViewController = [[AboutViewController alloc] initWithNibName:@"aboutView" bundle:nil];
  [[self navigationController] pushViewController:aboutViewController animated: YES];
  self.navigationController.navigationBarHidden = NO;
  [aboutViewController release];
}


#pragma mark TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if(section == 0) {
//    NSLog(@"-numberOfRowsInSection: %d 1", section);
    return 1; // return 1 for section 0 and MAX all other will be dynamic 
  }
  else {
    // we need to get at properties in our app delegate
    LexikonAppDelegate *appDelegate = (LexikonAppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSLog(@"%@", self.indexLetters);
    NSString *sectionLetter = [self.indexLetters objectAtIndex:section];
    NSMutableArray *wordsForSection = [appDelegate.currentWords objectForKey:sectionLetter];

//    NSLog(@"numberOfRowsInSection: %d %@ %d", section, sectionLetter, [wordsForSection count]);

    return [wordsForSection count];
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//  NSLog(@"# of sections %d", [self.indexLetters count]);
  return [self.indexLetters count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//  NSLog(@"indexTitlesForTableView %d", [self.indexLetters count]);
  return self.indexLetters;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  // return nil for the searchBar (1st section)
  if(section == 0) {
    return nil;
  }
  else {
    //    NSLog(@"section # %d", section);
    LexikonAppDelegate *appDelegate = (LexikonAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // if there are no words for a letter return a blank string so the UI isn't cluttered
    NSString *sectionLetter = [self.indexLetters objectAtIndex:section];
    NSMutableArray *wordsForSection = [appDelegate.currentWords objectForKey:sectionLetter];
    if(wordsForSection == nil || [wordsForSection count] == 0) {
      return @"";
    }
    else {
      return sectionLetter;
    }
  }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
  // searchBar cell gets its own identifier
  NSString *identifier = (indexPath.section == 0) ? @"search" : @"cell";
  
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
  if(cell == nil) {
    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
  }
  
  //NSLog(@"Row: %i,%i ID: %@", indexPath.section, indexPath.row, identifier);
  if(indexPath.section == 0) {
    // we don't need to redo the cell contents if they already exist
    if (self.mySearchBar == nil) {
      // TODO: navigation bar or image to fill in the gap so our seach bar can be 290 pixels and not over the index
      UINavigationBar *myNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
      [myNavigationBar setTintColor: [UIColor colorWithRed:0.769 green:0.80 blue:0.824 alpha:1.0]];
      [myNavigationBar sizeToFit];
      [cell.contentView addSubview:myNavigationBar];
      [myNavigationBar release];
    
      // Now add our search bar
      UISearchBar *aSearchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
      [aSearchBar setTintColor: [UIColor colorWithRed:0.769 green:0.80 blue:0.824 alpha:1.0]];
      [aSearchBar sizeToFit];
//      aSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
      aSearchBar.delegate = self;

      aSearchBar.frame = CGRectMake(0, 0, 290, 44);
      [cell.contentView addSubview:aSearchBar];
      self.mySearchBar = [aSearchBar retain];
      [aSearchBar release];
    }
  }
  else {
    LexikonAppDelegate *appDelegate = (LexikonAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *sectionLetter = [self.indexLetters objectAtIndex:indexPath.section];
    NSMutableArray *wordsForSection = [appDelegate.currentWords objectForKey:sectionLetter];
    
    cell.text = [[wordsForSection objectAtIndex:indexPath.row] word];
//    NSLog(@"SECTION: %d ROW: %d CELL: %@", indexPath.section, indexPath.row, cell.text);
  }
  
  return cell;
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  LexikonAppDelegate *appDelegate = (LexikonAppDelegate *)[[UIApplication sharedApplication] delegate];

  if (editingStyle == UITableViewCellEditingStyleDelete) {    
    // first remove from our word list and the database
    [appDelegate removeWordAtSectionLetter:[self.indexLetters objectAtIndex:indexPath.section] index:indexPath.row];
    // remove from the tableview
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  if(indexPath.section == 0) {
    return NO;
  }
  else {
    return YES;
  }
}
#pragma mark TableView Delegate

- (void)viewWord:(Word *) word {
  if (detailViewController == nil) {
    detailViewController = [[DetailViewController alloc] init];
  }
  
  // update the app delegate with what word we are viewing
  LexikonAppDelegate *appDelegate = (LexikonAppDelegate *)[[UIApplication sharedApplication] delegate];
  appDelegate.currentWord = word.word;  
  
  detailViewController.word = word.word;
  detailViewController.html = [[NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] 
                                                                   stringByAppendingPathComponent:@"translationTemplate.html"]]
                               stringByReplacingOccurrencesOfString:@"{yield}" withString:word.translation];
  
  [self.navigationController pushViewController:detailViewController animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    return nil;
  }
  LexikonAppDelegate *appDelegate = (LexikonAppDelegate *)[[UIApplication sharedApplication] delegate];
  NSMutableArray *wordsForSection = [appDelegate.currentWords objectForKey:[self.indexLetters objectAtIndex:indexPath.section]];
  Word *myWord = [wordsForSection objectAtIndex:indexPath.row];
  
  [self viewWord: myWord];
  
  return nil;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
  [self hideIndex:YES];
  
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
  [self hideIndex:NO];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  if(indexPath.section == 0) {
    return UITableViewCellEditingStyleNone;
  }
  else {
    return UITableViewCellEditingStyleDelete;
  }
}

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
  [self hideIndex:YES];
  searching = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
  NSLog(@"Should End Editing");
  [self hideIndex:NO];
  searching = NO;
  // just in case the language was toggled reload the table
  [tableView reloadData];
}

- (void)doneSearching {
  self.mySearchBar.text = @"";
  [self.mySearchBar resignFirstResponder];
}

- (void)hideIndex:(BOOL) hide {
  CGFloat factor = (hide) ? 30.0 : -30.0;

#ifdef DEBUG        
  LexikonAppDelegate *appDelegate = (LexikonAppDelegate *)[[UIApplication sharedApplication] delegate];
  NSLog(@"# of word arrays %d", [appDelegate.currentWords count]);
#endif
  UIBarButtonItem *buttonItem;
  
  // change the About button to a done button
  if (hide) {
    tableView.sectionIndexMinimumDisplayRowCount = NSIntegerMax;
    buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneSearching)];
  }
  else {
    tableView.sectionIndexMinimumDisplayRowCount = 1;
    buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(showAbout:)];
  }
  self.navigationItem.rightBarButtonItem = buttonItem;
  
  [buttonItem release];
  
  // setup the animation
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.4];
  
  // change the UISearchBar's size
  mySearchBar.frame = CGRectMake(mySearchBar.frame.origin.x, 
                                 mySearchBar.frame.origin.y, 
                                 mySearchBar.frame.size.width + factor, 
                                 mySearchBar.frame.size.height);  

  // move the index out of the way
  for ( UIView *view in tableView.subviews ) {
    if ([view isKindOfClass:NSClassFromString(@"UITableViewIndex")]) {
      view.center = CGPointMake(view.center.x + factor, view.center.y);
    }
  }
  [UIView commitAnimations];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
#ifdef DEBUG        
  NSLog(@"searching button clicked %@", searchBar);
#endif
  [searchBar resignFirstResponder];
  
  LexikonAppDelegate *appDelegate = (LexikonAppDelegate *)[[UIApplication sharedApplication] delegate];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

  NSString *translationString;
  NSString *translation;
  NSURL *translationURL;
  NSRange start, end;
  int encoding;
  
  if(appDelegate.swedishToEnglish) {
    translationString = [[NSString stringWithFormat:@"http://lexin.nada.kth.se/Lexin/?dict=sve-eng&lang=source&word=%@", searchBar.text] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    encoding = NSUTF8StringEncoding;
  }
  else {
    translationString = [[NSString stringWithFormat:@"http://lexin.nada.kth.se/cgi-bin/sve-eng?:%@", searchBar.text] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    encoding = NSISOLatin1StringEncoding;
  }
  
  // clean up the special chars  
  translationURL = [NSURL URLWithString:translationString];
    
  // get the html contents in a string
  NSError *myError;
  translation = [NSString stringWithContentsOfURL:translationURL encoding:encoding error:&myError];
  
  if(translation != nil) {
    start = [translation rangeOfString:@"<DL>"];
    end = [translation rangeOfString:@"</DL>" options:NSBackwardsSearch];
    if(! (start.location == NSNotFound && end.location == NSNotFound)) {
      NSRange myRange;
      myRange.location = start.location;
      myRange.length = end.location - start.location;
#ifdef DEBUG      
      NSLog(@"start: %d end: %d", start.location, end.location);
#endif      
      translation = [translation substringWithRange: myRange];

      Word *newWord = [[Word alloc] init];
      newWord.word = searchBar.text;
      newWord.lang = (appDelegate.swedishToEnglish) ? SWE_LANGUAGE : ENG_LANGUAGE;
      newWord.translation = translation;

      [appDelegate addWordToDictionary:appDelegate.currentWords word:newWord andDatabase:YES];
#ifdef DEBUG      
      NSLog(@"added now show");
#endif
      [self viewWord:newWord];
    }
    else {
      // display error message that the word was not found
      [self searchFailed:@"Word not found"];
    }
  }
  else {
    // display error message alerting the user that we were not able to contact the Lexin website
    [self searchFailed:@"Unable to reach the Lexin website"];
    //[NSString stringWithFormat:@"%@ %@", [myError localizedDescription], [myError localizedFailureReason]]];
  }  
  
  // hide the activity indicator
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  searchBar.text = @"";
}

- (void)searchFailed:(NSString *)message {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search Error" 
                                                  message:message
                                                 delegate:nil 
                                        cancelButtonTitle:@"OK" 
                                        otherButtonTitles: nil];
	[alert show];
	[alert release];  
}

@end