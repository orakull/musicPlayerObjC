//
//  Song.h
//  musicPlayerObjC
//
//  Created by Руслан Ольховка on 29.12.15.
//  Copyright © 2015 Руслан Ольховка. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

@property NSString* artist;
@property NSString* title;
@property NSString* picUrl;
@property NSString* demoUrl;

- (instancetype)initWithArtist:(NSString*)artist title:(NSString*)title picUrl:(NSString*)picUrl demoUrl:(NSString*)demoUrl;

@end
