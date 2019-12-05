//
//  PDEventRouter.h
//  PDEventRouter
//
//  Created by liang on 2019/12/5.
//  Copyright © 2019 liang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PDEventRouterResponse) {
    PDEventRouterResponseSuccess = 0,
    PDEventRouterResponseFailed  = 1,
};

@interface PDEventResponse : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSDictionary *data;

+ (instancetype)responseWithCode:(NSInteger)code message:(NSString *)message data:(NSDictionary *)data;
- (instancetype)initWithCode:(NSInteger)code message:(NSString *)message data:(NSDictionary *)data;

@end

@interface PDEventRouter : NSObject

@property (class, strong, readonly) PDEventRouter *globalRouter;

- (void)listen:(NSString *)uri handler:(void (^)(NSDictionary * _Nullable params, void (^callback)(PDEventResponse *)))handler;

- (void)request:(NSString *)uri params:(NSDictionary * _Nullable)params completion:(void (^ _Nullable)(PDEventResponse *response))completion;

@end

NS_ASSUME_NONNULL_END
