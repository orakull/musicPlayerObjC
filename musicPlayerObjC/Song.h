//
//  Song.h
//  musicPlayerObjC
//
//  Created by Руслан Ольховка on 29.12.15.
//  Copyright © 2015 Руслан Ольховка. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Song : NSObject

@property (nonatomic) NSString* artist;
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* picUrl;
@property (nonatomic) NSString* demoUrl;
@property (nonatomic) UIImage* image;

- (instancetype)initWithArtist:(NSString*)artist title:(NSString*)title picUrl:(NSString*)picUrl demoUrl:(NSString*)demoUrl;

@end
