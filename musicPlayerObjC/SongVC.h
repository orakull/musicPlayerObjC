//
//  SongVC.h
//  musicPlayerObjC
//
//  Created by Руслан Ольховка on 29.12.15.
//  Copyright © 2015 Руслан Ольховка. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface SongVC : UIViewController <SongDelegate>

@property (weak, nonatomic) Song *song;

@end

