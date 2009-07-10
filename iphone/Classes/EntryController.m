/*
 * Copyright (c) 2009, Richard Drake
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 *   1. Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 *   2. Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *   3. Neither the name of the Mobile Education Project, the University of
 *      Ontario Institute of Technology (UOIT), nor the names of its
 *      contributors may be used to endorse or promote products derived from
 *      this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#import "EntryController.h"


@implementation EntryController

@synthesize entry, webView, activityIndicator;

- (EntryController *)initWithEntry:(Entry *)e {
	if (self = [super initWithNibName:@"EntryView" bundle:nil]) {
		self.entry = e;
	}
	
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = self.entry.name;

	NSString *urlAddress = [[NSString alloc] initWithFormat:@"%@%d%@",
							[[NSUserDefaults standardUserDefaults] stringForKey:@"mirror_value"],
							[[NSUserDefaults standardUserDefaults] integerForKey:@"os_id_value"],
							self.entry.path];
	NSURL *url = [NSURL URLWithString:urlAddress];
	NSURLRequest *req = [NSURLRequest requestWithURL:url];
	[webView loadRequest:req];
	
	// The URL address is no longer required.  The web view, however, still requires the URL object
	// as well as the request object.  It takes care of their garbage collection, not us.
	[urlAddress release];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)webViewDidStartLoad:(UIWebView *)wv {
	self.view = activityIndicator;
    [activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)wv {
	self.view = webView;
    [activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
    [activityIndicator stopAnimating];
	
    if (error != NULL) {
        UIAlertView *errorAlert = [[UIAlertView alloc]
								   initWithTitle: [error localizedDescription]
								   message: [error localizedFailureReason]
								   delegate:nil
								   cancelButtonTitle:@"OK" 
								   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
    }
}

- (void)dealloc {
    [super dealloc];
	
	//[self.entry dealloc];
}


@end
