//
//  ProvisioningProfileParser.h
//  ProvisioningProfileParser
//
//  Created by jsonmess on 2023/10/13.
//

#import <Foundation/Foundation.h>
#import <ProvisioningProfileParser/ProvisioningProfile.h>

@interface ProvisioningProfileParser : NSObject

//获取   默认mainBundle 下“embedded.mobileprovision”
- (void)fetchLocaProvisioningProfile:(void (^_Nullable)(ProvisionProfileInfo * _Nullable  profile, NSError *_Nullable error))completion;

//获取指定的provisionProfile 文件
- (void)fetchLocaProvisioningProfileWithBundle:(nonnull NSBundle*)bundle
                                                        fileName:(nonnull NSString*)fileName
                                     completed:(void (^_Nullable)(ProvisionProfileInfo *_Nullable profile, NSError * _Nullable error))completion;

@end

