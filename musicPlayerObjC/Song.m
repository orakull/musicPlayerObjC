//
//  Song.m
//  musicPlayerObjC
//
//  Created by Руслан Ольховка on 29.12.15.
//  Copyright © 2015 Руслан Ольховка. All rights reserved.
//

#import "Song.h"

@implementation Song

//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//	self = [super initWithCoder:coder];
//	if (self) {
//		<#statements#>
//	}
//	return self;
//}

- (instancetype)initWithArtist:(NSString *)artist title:(NSString *)title picUrl:(NSString *)picUrl demoUrl:(NSString *)demoUrl {
	self = [super init];
	if (self) {
		self.artist = artist;
		self.title = title;
		self.picUrl = picUrl;
		self.demoUrl = demoUrl;
	}
	return self;
}

@end