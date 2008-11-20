//
//  MainViewController.h
//  Lexikon
//
//  Created by Caleb Jaffa
//  Copyright 2008 Caleb Jaffa, MIT licensed
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface MainViewController : UIViewController <UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource> {
  IBOutlet UITableView *tableView;
  IBOutlet UIBarButtonItem *languageSwitcherButton;

  NSMutableArray *indexLetters;  
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *indexLetters;

- (IBAction)switchLanguage:(id)sender;
- (void)changeIndexLetters:(BOOL) swedish;

#pragma mark searchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;

@end
