//
//  AboutViewController.m
//  Lexikon
//
//  Created by Caleb Jaffa on 1/3/09.
//  Copyright 2008-2009 Caleb Jaffa, MIT licensed
//

#import "AboutViewController.h"


@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  NSString *version  = [[[NSBundle mainBundle] infoDictionary] valueForKey:[NSString stringWithFormat:@"CFBundleShortVersionString"]];
  
  NSString *build  = [[[NSBundle mainBundle] infoDictionary] valueForKey:[NSString stringWithFormat:@"CFBundleVersion"]];
  
  NSString *html = [[[NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] 
                                                         stringByAppendingPathComponent:@"aboutView.html"]]
                     stringByReplacingOccurrencesOfString:@"{version}" withString:version]
                    stringByReplacingOccurrencesOfString:@"{build}" withString:build];
  
  // by passing the bundle as the url we can reference the logo mark easily in the html
  [webView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
  self.title = @"About";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
