//
//  UserInfoModel.h
//  ReadCard
//
//  Created by 夜猫子 on 2023/10/20.
//


#import "ImageProcessor.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ReadCard-Swift.h"

API_AVAILABLE(ios(13.0))
@interface UserInfoModel : NSObject

//扫描原来数据
@property(nonatomic,copy)NSString * _Nullable rawData;

/// 名字
@property(nonatomic,copy)NSString * _Nullable userName;

/// 身份证号码
@property(nonatomic,copy)NSString * _Nullable identificationCard;


/// 生日
@property(nonatomic,copy)NSString * _Nullable birthday;

/// 性别
@property(nonatomic,copy)NSString * _Nullable gender;

/// 调用此方法，获取用户姓名身份证号码信息
/// - Parameters:
///   - inputImage: 图片
///   - cardType: 卡片类型
///   - completion 模型回调
+ (void)getUserInfoModelWithImage:(UIImage *_Nullable)inputImage withCardType:(CardType)cardType completion:(void (^_Nullable)(UserInfoModel * _Nullable))completion NS_AVAILABLE_IOS(13.0);


/// 传入字符串，获取用户名称和身份证字号
/// - Parameters:
///   - text: 字符串
///   - cardType: 卡片类型
+ (UserInfoModel *_Nullable)extractUserInfoFromText:(NSString *_Nullable)text withCardType:(CardType)cardType;

@end


