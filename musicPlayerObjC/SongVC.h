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

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

- (IBAction)playPause;
- (IBAction)sliderTouchUpInside;

@end
