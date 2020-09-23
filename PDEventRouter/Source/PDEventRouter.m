//
//  PDEventRouter.m
//  PDEventRouter
//
//  Created by liang on 2019/12/5.
//  Copyright © 2019 liang. All rights reserved.
//

#import "PDEventRouter.h"

PDEventRouterResponseCode const PDEventRouterResponseCodeUndefined  = NSNotFound;
PDEventRouterResponseCode const PDEventRouterResponseCodeSuccess    = 0;
PDEventRouterResponseCode const PDEventRouterResponseCodeFailed     = 948392430293;

#define Lock() dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER)
#define Unlock() dispatch_semaphore_signal(self->_lock)

@implementation PDEventResponse

+ (instancetype)responseWithCode:(NSInteger)code message:(NSString *)message data:(NSDictionary *)data {
    return [[self alloc] initWithCode:code message:message data:data];
}

- (instancetype)initWithCode:(NSInteger)code message:(NSString *)message data:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _code = code;
        _message = [message copy];
        _data = [data copy];
    }
    return self;
}

@end

@implementation PDEventRouter {
    dispatch_semaphore_t _lock;
    NSMutableDictionary<NSString *, void (^)(NSDictionary *, void (^)(PDEventResponse *))> *_listener;
}

+ (PDEventRouter *)globalRouter {
    static PDEventRouter *__globalRouter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __globalRouter = [[self alloc] init];
    });
    return __globalRouter;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _lock = dispatch_semaphore_create(1);
        _listener = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)listen:(NSString *)uri handler:(void (^)(NSDictionary * _Nullable, void (^ _Nonnull)(PDEventResponse * _Nonnull)))handler {
    Lock();
    _listener[uri] = handler;
    Unlock();
}

- (void)resignListen:(NSString *)uri {
    Lock();
    [_listener removeObjectForKey:uri];
    Unlock();
}

- (void)request:(NSString *)uri params:(NSDictionary *)params completion:(void (^)(PDEventResponse * _Nonnull))completion {
    Lock();
    void (^handler)(NSDictionary *, void (^)(PDEventResponse *)) = _listener[uri];
    Unlock();
    
    if (!handler) {
        NSString *message = [NSString stringWithFormat:@"Can not found uri `%@`!", uri];
        PDEventResponse *response = [[PDEventResponse alloc] initWithCode:PDEventRouterResponseCodeUndefined message:message data:nil];
        !completion ?: completion(response);
        return;
    }
    
    handler(params, ^(PDEventResponse *response) {
        !completion ?: completion(response);
    });
}

@end
