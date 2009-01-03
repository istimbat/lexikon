//
//  AboutViewController.h
//  Lexikon
//
//  Created by Caleb Jaffa on 1/3/09.
//  Copyright 2008-2009 Caleb Jaffa, MIT licensed
//

#import <UIKit/UIKit.h>


@interface AboutViewController : UIViewController {
  IBOutlet UIWebView *webView;
}

- (NSString *)stringFromFileSize:(int)theSize;

@end
