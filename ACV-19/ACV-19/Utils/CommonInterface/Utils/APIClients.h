//
//  APIClients.h
//  MapCao
//
//  Created by VoHuy on 2020/10/13.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "API.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIClients : NSObject
+ (void)getListPatient:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError* _Nullable error))failure;

+ (void)getNews:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError* _Nullable error))failure;

+ (void)getPatientStatistic:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError* _Nullable error))failure;

+ (void)getPatientStatisticOverView:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError* _Nullable error))failure;

+ (void)getPatientStatisticTotal:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError* _Nullable error))failure;

+ (void)getDirectings:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError* _Nullable error))failure;

+ (void)getPatientDetail:(NSString *)city success:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError* _Nullable error))failure;

+ (void)getNewsGovernment:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError* _Nullable error))failure;
@end

NS_ASSUME_NONNULL_END
