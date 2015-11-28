//
//  AppDelegate.m
//  Tech Digest
//
//  Created by Robert Varga on 12/09/2015.
//  Copyright (c) 2015 Robert Varga. All rights reserved.
//

#import "AppDelegate.h"

//alert view
#import "RKDropdownAlert.h"
//colors
#import <ChameleonFramework/Chameleon.h>
//reachability (connection)
#import <AFNetworkReachabilityManager.h>
//parse
#import <Parse/Parse.h>
#import "PFArticle.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    //PARSE base setup
    [Parse enableLocalDatastore];
    // Initialize Parse.
    [Parse setApplicationId:@"qKpgNk7qQyYyl4Yn98O4vhYP4xuPVpKfRHROA1Us" clientKey:@"bUGTIANQ7t6IZbpWJtTEeMWlycereNKsLM78oZaV"];
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    


    //DETECT INTERNET CONNECTION
    [self reachabilityCheck];

    //pormpt to rate APP
    [self rateApp];
    
    
    return YES;
}


-(void)reachabilityCheck {
    //start monitor
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    //Checking the Internet connection...
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            //connection exists
            [RKDropdownAlert dismissAllAlert];
        }else{
            // NO connection
            [RKDropdownAlert title:@"No Internet Connection" backgroundColor:[UIColor colorWithHexString:@"FA275C" withAlpha:0.95] textColor:[UIColor whiteColor]];
        }
    }];
}


- (void)rateApp {
    
    int launchCount = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"launchCount"];
    launchCount++;
    [[NSUserDefaults standardUserDefaults] setInteger:launchCount forKey:@"launchCount"];
    
    BOOL neverRate = [[NSUserDefaults standardUserDefaults] boolForKey:@"neverRate"];
    
    if ((neverRate != YES) && (launchCount > 2)) {
        //alert view
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Rate Tech Digest"
                                                                       message:@"If you enjoy using Tech Digest, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* laterAction = [UIAlertAction actionWithTitle:@"Remind me later" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
        UIAlertAction* rateAction = [UIAlertAction actionWithTitle:@"Rate now" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //open in App Store
                                                             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"neverRate"];
                                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=661175387"]];
                                                         }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"No, Thanks" style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction * action) {
                                                               [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"neverRate"];
                                                           }];
    
        [alert addAction:rateAction];
        [alert addAction:laterAction];
        [alert addAction:cancelAction];

        //present alertView
        [self.window makeKeyAndVisible];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    }

}

//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"neverRate"];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=661175387"]];
//    }
//    
//    else if (buttonIndex == 1) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"neverRate"];
//    }
//    
//    else if (buttonIndex == 2) {
//        // Do nothing
//    }
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
