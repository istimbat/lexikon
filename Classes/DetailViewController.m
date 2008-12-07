//
//  DetailViewController.m
//  Lexikon
//
//  Created by Caleb Jaffa on 12/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

@synthesize webView, word, html;

- (void)loadView {
  NSLog(@"loadView");
  webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
  self.view = webView;
}

- (void)viewWillAppear:(BOOL)animated {  
  [super viewWillAppear:animated];
  self.title = word;
  [webView loadHTMLString:html baseURL:[NSURL URLWithString:word]];  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
  NSLog(@"dealloc detailViewController");
  [webView release];
  [word release];
  [html release];
  [super dealloc];
}


@end
