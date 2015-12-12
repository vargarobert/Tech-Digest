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
//Date utils
#import "DateUtils.h"
//PARSE utils
#import "PFUtils.h"
//HTTP codes
#import "FTHTTPCodes.h"

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

    //setup NOTIFICATIONS
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self setupNotifications];
    //reset badge
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        application.applicationIconBadgeNumber = 0;
    }
    
    //DETECT INTERNET CONNECTION
    [self reachabilityCheck];

    //pormpt to rate APP
    [self rateApp];
    
    
    return YES;
}

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return true;
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
    
    if ((neverRate != YES) && (launchCount > 7)) {
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
                                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1038551733&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
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

-(void)setupNotifications {
    //Ask to register the NOTIFICATIONS
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *notifSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notifSettings];
    
    //schedule notification only once
//    if(![NSUserDefaultsUtils isObjectMarkedAsTrue:@"scheduledLocalNotification"]) {
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDate *now = [NSDate date];
        NSDateComponents *componentsForFireDate = [calendar components:(NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate: now];
        [componentsForFireDate setHour: 8] ; //for fixing 8AM hour
        [componentsForFireDate setMinute:0] ;
        [componentsForFireDate setSecond:0] ;
        
        NSDate *fireDateOfNotification = [calendar dateFromComponents: componentsForFireDate];
        UILocalNotification *notification = [[UILocalNotification alloc] init] ;
        notification.repeatInterval = NSCalendarUnitDay;
        notification.fireDate = fireDateOfNotification ;
        notification.timeZone = [NSTimeZone localTimeZone] ;
        notification.alertBody = [NSString stringWithFormat: @"Your daily Tech Digest is ready."] ;
        notification.userInfo= [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"New technology digest added for that day!"] forKey:@"new"];
        notification.soundName=UILocalNotificationDefaultSoundName;
        notification.applicationIconBadgeNumber = 1;
        
        NSLog(@"notification: %@",notification);//it indicates when the notification will be triggered
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
//        [NSUserDefaultsUtils markObjectAsTrue:@"scheduledLocalNotification"];
//    }
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Fetch started");
    
    //get today's DATE for current location with time 00:00:00
    NSDate *today = [DateUtils resetTimeFromDateByLocation:[NSDate date]];
    [self getDataForDate:today];
    
    NSLog(@"Fetch completed");
}

- (void)getDataForDate:(NSDate*)today {
    //prepare yesterday date incase no data for today
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                 value:-1
                                                                toDate:today
                                                               options:0];
    
    [PFUtils _getArticlesFromCloudForDate:today completion:^(int HTTPCode, NSArray *array) {
        if (HTTPCode==HTTPCode204NoContent) {
            //NO results
            //get date -1
            [self getDataForDate:yesterday];
        } else {
            //reload table data only if new data
            if (HTTPCode==HTTPCode200OK) {
                //save new data to localdatastore
                [PFObject pinAllInBackground:array];
            }
        }
    }];
}

//By tapping on action button of the notification, users will launch the app. Then reset the number on badge
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    application.applicationIconBadgeNumber = 0;
}

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
    
    //reset badge
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
