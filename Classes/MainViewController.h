//
//  MainViewController.h
//  Lexikon
//
//  Created by Caleb Jaffa
//  Copyright 2008 Caleb Jaffa, MIT licensed
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class DetailViewController;

@interface MainViewController : UITableViewController <UISearchBarDelegate> {
  IBOutlet UITableView *tableView;
  IBOutlet UIBarButtonItem *languageSwitcherButton;
  UISearchBar *mySearchBar;
  DetailViewController *detailViewController;
  
  NSMutableArray *indexLetters;
  BOOL searching;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UISearchBar *mySearchBar;
@property (nonatomic, retain) NSMutableArray *indexLetters;

- (IBAction)switchLanguage:(id)sender;
- (void)changeIndexLetters:(BOOL) swedish;

- (void)viewWord:(Word *) word;
  
#pragma mark searchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;

- (void)hideIndex:(BOOL) hide;
@end
