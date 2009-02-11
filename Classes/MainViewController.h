//
//  MainViewController.h
//  Lexikon
//
//  Created by Caleb Jaffa
//  Copyright 2008-2009 Caleb Jaffa, MIT licensed
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SearchSuggestionsController.h"

@class DetailViewController, Word, AboutViewController;

@interface MainViewController : UITableViewController <UISearchBarDelegate> {
  IBOutlet UITableView *tableView;
  IBOutlet UIBarButtonItem *languageSwitcherButton;
  UISearchBar *mySearchBar;
  DetailViewController *detailViewController;
  UIButton *cancelSearchTableCover;
//  UIView *suggestionsView;
  SearchSuggestionsController *suggestionsController;
//  UIImageView *dropShadow;
  
  NSMutableArray *indexLetters;
  BOOL searching;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UISearchBar *mySearchBar;
@property (nonatomic, retain) NSMutableArray *indexLetters;
//@property (nonatomic, retain) UIView *suggestionsView;
@property (nonatomic, retain) SearchSuggestionsController *suggestionsController;
//@property (nonatomic, retain) UIImageView *dropShadow;

- (IBAction)switchLanguage:(id)sender;
- (IBAction)showAbout:(id)sender;
- (void)changeIndexLetters:(BOOL) swedish;

- (void)viewWord:(Word *) word;
- (void)searchFailed:(NSString *)message;
- (void)shiftOverlaysOff:(BOOL) shiftOff;

- (void)hideIndex:(BOOL) hide;
@end
