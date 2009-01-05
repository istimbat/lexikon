//
//  DetailViewController.m
//  Lexikon
//
//  Created by Caleb Jaffa on 12/4/08.
//  Copyright 2008-2009 Caleb Jaffa, MIT licensed
//

#import "DetailViewController.h"
#import "LexikonAppDelegate.h"

@implementation DetailViewController

@synthesize webView, word, html;

- (void)loadView {
  webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
  self.view = webView;
}

- (void)viewWillAppear:(BOOL)animated {  
  [super viewWillAppear:animated];
  self.title = word;
  [webView loadHTMLString:html baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1/%@", word]]];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [word release];
  word = nil;
  [html release];
  html = nil;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
  // Release anything that's not essential, such as cached data
}


- (void)dealloc {
  [webView release];
  [word release];
  [html release];
  [super dealloc];
}


@end
