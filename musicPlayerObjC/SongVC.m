//
//  SongVC.m
//  musicPlayerObjC
//
//  Created by Руслан Ольховка on 29.12.15.
//  Copyright © 2015 Руслан Ольховка. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "SongVC.h"

@interface SongVC () {
	AVPlayer *player;
	AVPlayerItem *playerItem;
	CADisplayLink *updater;
}
@end

@implementation SongVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.imageView.image = self.song.image;
	self.title = self.song.title;
	
	NSURL *url = [[NSURL alloc] initWithString:self.song.demoUrl];
	playerItem = [[AVPlayerItem alloc] initWithURL:url];
	[playerItem addObserver:self forKeyPath:@"status" options: NSKeyValueObservingOptionInitial context:NULL];
	
	player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
	[player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:NULL];
	
	updater = [CADisplayLink displayLinkWithTarget:self selector:@selector(trackAudio)];
	updater.frameInterval = 1;
	[updater addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)viewDidDisappear:(BOOL)animated {
	[playerItem removeObserver:self forKeyPath:@"status"];
	[player removeObserver:self forKeyPath:@"rate"];
	[updater invalidate];
}

- (void)trackAudio {
	if (self.progressSlider.highlighted) {
		
	} else {
		self.positionLabel.text = [self stringFromTime:player.currentTime.value / player.currentTime.timescale];
		if (playerItem.duration.value > 0) {
			Float64 currentSeconds = (Float64)player.currentTime.value / (Float64)player.currentTime.timescale;
			Float64 durationSeconds = (Float64)playerItem.duration.value / (Float64)playerItem.duration.timescale;
			self.progressSlider.value = currentSeconds / durationSeconds;
		}
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"status"]) {
		if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
			double seconds = playerItem.duration.value / playerItem.duration.timescale;
			self.durationLabel.text = [self stringFromTime:seconds];
		}
	}
	if ([keyPath isEqualToString:@"rate"]) {
		self.playPauseButton.selected = player.rate == 1.0;
	}
}

- (NSString*)stringFromTime:(double)time {
	int t = time;
	return [NSString stringWithFormat:@"%02i:%02i", t / 60 , t % 60];
}

#pragma mark - Actions

- (IBAction)playPause {
	if (self.playPauseButton.selected) {
		[player pause];
	} else {
		[player play];
	}
}

- (IBAction)sliderTouchUpInside {
	Float64 seconds = self.progressSlider.value * (Float64)playerItem.duration.value / (Float64)playerItem.duration.timescale;
	CMTime time = CMTimeMakeWithSeconds(seconds, playerItem.duration.timescale);
	[player seekToTime:time];
}

@end
