//
//  ProvisionProFileInfo.h
//  ProvisioningProfileParser
//
//  Created by jsonmess on 2023/10/13.
//

#import <Foundation/Foundation.h>

@interface ProvisionProfileInfo : NSObject
@property (copy, nonatomic)  NSString *provisionName;//描述文件名称
@property (copy, nonatomic)  NSString *team; //Team
@property (copy, nonatomic)  NSString *provisionExpiry;//描述文件过期时间
@property (strong, nonatomic)  NSDate *provisionExpiryDate;//描述文件过期时间Date
@property (copy, nonatomic)  NSString *certificateName;//证书名称
@property (copy, nonatomic)  NSString *certificateCreateTime;//证书创建日期
@property (strong, nonatomic)  NSDate *certificateCreateDate;//证书创建日期Date

@end
