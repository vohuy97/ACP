//
//  APIClients.m
//  MapCao
//
//  Created by VoHuy on 2020/10/13.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import "APIClients.h"
#import "AFHTTPSessionManager.h"
#import "Utils.h"

@implementation APIClients

+ (AFHTTPSessionManager*)getMananer {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:15];  //Time out after 15 seconds
    return manager;
}

+ (void)getListPatient:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError* _Nullable error))failure {
    NSLog(@"%s", __func__);
    AFHTTPSessionManager *manager = [self getMananer];
    NSString *url = LIST_PATIENT_API;

    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [Utils showAlertWithContentServerError:@"Kết nối server thất bại"];
        if (failure)
            failure(error);
    }];
}

+ (NSString *)checkNullValue:(NSString *)value {
    return value ? value : @"";
}

+ (void)getNews:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError* _Nullable error))failure {
    NSLog(@"%s", __func__);
    AFHTTPSessionManager *manager = [self getMananer];
    NSString *url = NEWS_API;

    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [Utils showAlertWithContentServerError:@"Kết nối server thất bại"];
        if (failure)
            failure(error);
    }];
}

+ (void)getNewsGovernment:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError* _Nullable error))failure {
    NSLog(@"%s", __func__);
    AFHTTPSessionManager *manager = [self getMananer];
    NSString *url = NEWS_GOVERNMENT_API;

    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [Utils showAlertWithContentServerError:@"Kết nối server thất bại"];
        if (failure)
            failure(error);
    }];
}

+ (void)getPatientStatistic:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError* _Nullable error))failure {
    NSLog(@"%s", __func__);
    AFHTTPSessionManager *manager = [self getMananer];
    NSString *url = NEWS_PATIENT_STATISIC;

    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [Utils showAlertWithContentServerError:@"Kết nối server thất bại"];
        if (failure)
            failure(error);
    }];
}

+ (void)getPatientStatisticOverView:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError* _Nullable error))failure {
    NSLog(@"%s", __func__);
    AFHTTPSessionManager *manager = [self getMananer];
    NSString *url = NEWS_PATIENT_STATISIC_OVER_VIEW;

    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [Utils showAlertWithContentServerError:@"Kết nối server thất bại"];
        if (failure)
            failure(error);
    }];
}

+ (void)getPatientStatisticTotal:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError* _Nullable error))failure {
    NSLog(@"%s", __func__);
    AFHTTPSessionManager *manager = [self getMananer];
    NSString *url = NEWS_PATIENT_STATISIC_TOTAL;

    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [Utils showAlertWithContentServerError:@"Kết nối server thất bại"];
        if (failure)
            failure(error);
    }];
}

+ (void)getDirectings:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError* _Nullable error))failure {
    NSLog(@"%s", __func__);
    AFHTTPSessionManager *manager = [self getMananer];
    NSString *url = DIRECTING_API;

    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [Utils showAlertWithContentServerError:@"Kết nối server thất bại"];
        if (failure)
            failure(error);
    }];
}

+ (void)getPatientDetail:(NSString *)city success:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError* _Nullable error))failure {
    NSLog(@"%s", __func__);
    AFHTTPSessionManager *manager = [self getMananer];
    NSString *url = [NSString stringWithFormat:PATINET_DETAIL_API, city];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:city ? city : @"" forKey:@"address"];
    NSString *encoded = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:encoded parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [Utils showAlertWithContentServerError:@"Kết nối server thất bại"];
        if (failure)
            failure(error);
    }];
}

@end
