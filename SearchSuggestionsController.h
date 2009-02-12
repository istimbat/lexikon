//
//  SearchSuggestionsController.h
//  Lexikon
//
//  Created by Caleb Jaffa on 2/8/09.
//  Copyright 2008-2009 Caleb Jaffa, MIT licensed
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface SearchSuggestionsController : UIViewController {
  IBOutlet UITableView *tableView;
  IBOutlet UIImageView *dropDownShadow;
  NSMutableArray *suggestions;
  MainViewController *main;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIImageView *dropDownShadow;
@property (nonatomic, retain) NSMutableArray *suggestions;
@property (nonatomic, retain) MainViewController *main;

@end
