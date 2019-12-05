//
//  AppDelegate.m
//  PDEventRouter
//
//  Created by liang on 2019/12/5.
//  Copyright © 2019 liang. All rights reserved.
//

#import "AppDelegate.h"
#import "PDEventRouter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self listen];
    return YES;
}

- (void)listen {
    PDEventRouter *router = [PDEventRouter globalRouter];
    
    [router listen:@"pipe://event/demo" handler:^(NSDictionary * _Nullable params, void (^ _Nonnull callback)(PDEventResponse * _Nonnull)) {
        NSLog(@"params = %@", params);
        
        PDEventResponse *response = [PDEventResponse responseWithCode:PDEventRouterResponseSuccess
                                                              message:@"success"
                                                                 data:@{@"key": @"value"}];
        !callback ?: callback(response);
    }];
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
