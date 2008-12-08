//
//  DetailViewController.h
//  Lexikon
//
//  Created by Caleb Jaffa on 12/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailViewController : UIViewController {
  UIWebView *webView;
  NSString *word;  
  NSString *html;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, copy) NSString *word;
@property (nonatomic, copy) NSString *html;

@end
