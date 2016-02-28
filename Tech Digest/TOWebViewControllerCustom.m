//
//  TOWebViewControllerCustom.m
//  Tech Digest
//
//  Created by Robert Varga on 22/02/2016.
//  Copyright © 2016 Robert Varga. All rights reserved.
//

#import "TOWebViewControllerCustom.h"

@implementation TOWebViewControllerCustom

+(void)openModalWebBrowserWithURL:(NSURL*)url {
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:navigationController animated:YES completion:NULL];
}

@end
