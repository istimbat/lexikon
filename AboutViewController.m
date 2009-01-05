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
  // get the version and build numbers for substituting into the html document
  NSString *version  = [[[NSBundle mainBundle] infoDictionary] valueForKey:[NSString stringWithFormat:@"CFBundleShortVersionString"]];
  NSString *build  = [[[NSBundle mainBundle] infoDictionary] valueForKey:[NSString stringWithFormat:@"CFBundleVersion"]];
  
  // get the size of the database for substituting into the html document
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *DBPath = [documentsDirectory stringByAppendingPathComponent:@"database.sqlite3"];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSDictionary *database = [fileManager fileAttributesAtPath:DBPath traverseLink:YES];
  NSString *filesize = [self stringFromFileSize:[database fileSize]];
  
  // set the html document up, substituting in some variables
  NSString *html = [[[[NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] 
                                                         stringByAppendingPathComponent:@"aboutView.html"]]
                      stringByReplacingOccurrencesOfString:@"{version}" withString:version]
                     stringByReplacingOccurrencesOfString:@"{build}" withString:build]
                    stringByReplacingOccurrencesOfString:@"{filesize}" withString:filesize];
  
  
  // by passing the bundle as the url we can reference the logo mark easily in the html
  [webView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
  self.title = @"About";
  
}

- (NSString *)stringFromFileSize:(int)theSize {
	float floatSize = theSize;
	if (theSize<1023) {
		return([NSString stringWithFormat:@"%i bytes",theSize]);    
  }

	floatSize = floatSize / 1024;

	if (floatSize<1023) {
		return([NSString stringWithFormat:@"%1.1f KB",floatSize]);    
  }
	
  floatSize = floatSize / 1024;
	
  if (floatSize<1023) {    
		return([NSString stringWithFormat:@"%1.1f MB",floatSize]);
  }
	
  floatSize = floatSize / 1024;

	return([NSString stringWithFormat:@"%1.1f GB",floatSize]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


// send external web requests and mail links to be handled by the default app (Safari, mail, etc.)
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
  NSURL *loadURL = [[request URL] retain]; // retain the loadURL for use
  if (([[loadURL scheme] isEqualToString: @"http"] || 
       [[loadURL scheme] isEqualToString: @"https"] || 
       [[loadURL scheme] isEqualToString: @"mailto"] ||
       [[loadURL scheme] isEqualToString: @"tel"] ||
       [[loadURL scheme] isEqualToString: @"sms"]) && 
      (navigationType == UIWebViewNavigationTypeLinkClicked)) // Check if the scheme is http/https. You can also use these for custom links to open parts of your application.
    return ![[UIApplication sharedApplication] openURL:[loadURL autorelease]]; // Auto release the loadurl because we wont get to release later. then return the opposite of openURL, so if safari cant open the url, open it in the UIWebView.
  [loadURL release];
  return YES; // URL is not http/https and should open in UIWebView
}


@end
