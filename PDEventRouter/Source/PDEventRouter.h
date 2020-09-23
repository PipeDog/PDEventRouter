//
//  PDEventRouter.h
//  PDEventRouter
//
//  Created by liang on 2019/12/5.
//  Copyright © 2019 liang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// @brief 状态码类型定义，支持扩展
typedef NSInteger PDEventRouterResponseCode NS_TYPED_ENUM;

FOUNDATION_EXPORT PDEventRouterResponseCode const PDEventRouterResponseCodeUndefined;   ///< 事件未注册
FOUNDATION_EXPORT PDEventRouterResponseCode const PDEventRouterResponseCodeSuccess;     ///< 执行成功
FOUNDATION_EXPORT PDEventRouterResponseCode const PDEventRouterResponseCodeFailed;      ///< 执行失败

/// @class PDEventResponse
/// @brief 事件响应实例
@interface PDEventResponse : NSObject

/// @brief 状态码
@property (nonatomic, assign) PDEventRouterResponseCode code;
/// @brief 回调信息
@property (nonatomic, copy, nullable) NSString *message;
/// @brief 响应数据
@property (nonatomic, copy, nullable) NSDictionary *data;

/// @brief 便捷初始化方法
/// @param code 状态码
/// @param message 回调信息
/// @param data 响应数据
/// @return 响应实例
+ (instancetype)responseWithCode:(PDEventRouterResponseCode)code
                         message:(NSString * _Nullable)message
                            data:(NSDictionary * _Nullable)data;

/// @brief 便捷初始化方法
/// @param code 状态码
/// @param message 回调信息
/// @param data 响应数据
/// @return 响应实例
- (instancetype)initWithCode:(PDEventRouterResponseCode)code
                     message:(NSString * _Nullable)message
                        data:(NSDictionary * _Nullable)data;

@end

/// @class PDEventRouter
/// @brief 事件路由，采用 client - server 模式，主要用于解偶场景
@interface PDEventRouter : NSObject

/// @brief 单例对象
@property (class, strong, readonly) PDEventRouter *globalRouter;

/// @brief 注册监听事件，相当于 server 侧启动监听
/// @param uri 监听地址，不需要有严格的格式
/// @param handler 事件处理 block
- (void)listen:(NSString *)uri
       handler:(void (^)(NSDictionary * _Nullable params, void (^callback)(PDEventResponse *)))handler;

/// @brief 取消 uri 地址的事件监听
/// @param uri 监听地址，不需要有严格的格式
- (void)resignListen:(NSString *)uri;

/// @brief 向 uri 发送消息并获取结果，相当于 client 向 server 发送请求
/// @param uri 监听地址，不需要有严格的格式
/// @param params 携带的数据内容
/// @param completion 接收回调 block
- (void)request:(NSString *)uri
         params:(NSDictionary * _Nullable)params
     completion:(void (^ _Nullable)(PDEventResponse *response))completion;

@end

NS_ASSUME_NONNULL_END
