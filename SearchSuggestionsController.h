//
//  SearchSuggestionsController.h
//  Lexikon
//
//  Created by Caleb Jaffa on 2/8/09.
//  Copyright 2008-2009 Caleb Jaffa, MIT licensed
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface SearchSuggestionsController : UITableViewController {
  IBOutlet UITableView *tableView;
  NSMutableArray *suggestions;
  MainViewController *main;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *suggestions;
@property (nonatomic, retain) MainViewController *main;

@end
