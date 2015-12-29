//
//  MusicTableVC.m
//  musicPlayerObjC
//
//  Created by Руслан Ольховка on 29.12.15.
//  Copyright © 2015 Руслан Ольховка. All rights reserved.
//

#import "MusicTableVC.h"
#import "Song.h"
#import "SongVC.h"

@interface MusicTableVC () {
	NSMutableArray* songs;
	NSInteger loaded;
	BOOL loadedAll;
}
@end

@implementation MusicTableVC

- (NSString*)preparedURL {
	NSMutableString *url = [[NSMutableString alloc] initWithString:@"https://api-content-beeline.intech-global.com/public/marketplaces/1/tags/10/melodies"];
	[url appendFormat:@"?limit=10&from=%d", (int)loaded];
	return url;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		songs = [[NSMutableArray alloc] init];
		loaded = 0;
		loadedAll = NO;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self getSongs];
}

- (void)getSongs {
	[self downloadUrl:[self preparedURL] completeHandler:^(NSData * _Nullable data) {
		NSError *error = nil;
		NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
		if (error) {
			NSLog(@"error %@", error.localizedDescription);
		} else {
			[self extractJSON:json];
		}
	}];
}

- (void)extractJSON:(NSDictionary*)json {
	NSDictionary *melodies = [json objectForKey:@"melodies"];
	NSEnumerator *enumerator = [melodies objectEnumerator];
	NSDictionary *melody;
	if (melodies.count < 10) {
		loadedAll = YES;
	}
	loaded += melodies.count;
	while (melody = [enumerator nextObject]) {
		NSString *artist = [melody objectForKey:@"artist"];
		NSString *title = [melody objectForKey:@"title"];
		NSString *picUrl = [melody objectForKey:@"picUrl"];
		NSString *demoUrl = [melody objectForKey:@"demoUrl"];
		Song *song = [[Song alloc] initWithArtist:artist title:title picUrl:picUrl demoUrl:demoUrl];
		[songs addObject:song];
	}
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.tableView reloadData];
	});
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return songs.count + (loadedAll ? 0 : 1);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!loadedAll && indexPath.row == songs.count - 1) {
		[self getSongs];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < songs.count) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songCell" forIndexPath:indexPath];
		
		Song *song = [songs objectAtIndex:indexPath.row];
		
		cell.textLabel.text = song.title;
		cell.detailTextLabel.text = song.artist;
		if (song.image) {
			cell.imageView.image = song.image;
		} else {
			cell.imageView.image = [UIImage imageNamed:@"noAlbumArt"];
			[self downloadUrl:song.picUrl completeHandler:^(NSData * _Nullable data) {
				dispatch_async(dispatch_get_main_queue(), ^{
					song.image = [[UIImage alloc] initWithData:data];
					cell.imageView.image = song.image;
				});
			}];
		}
		
		return cell;
	} else {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadingCell" forIndexPath:indexPath];
		return cell;
	}
	
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	SongVC *svc = segue.destinationViewController;
	if (svc) {
		UITableViewCell *cell = sender;
		if (cell) {
			int index = (int)[self.tableView indexPathForCell:cell].row;
			id song = [songs objectAtIndex:index];
			svc.song = song;
		}
	}
}

#pragma mark - utils

-(void)downloadUrl:(NSString*)downloadUrl
   completeHandler:(void (^)(NSData* __nullable data))handler {
	NSURL *url = [[NSURL alloc] initWithString:downloadUrl];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	[NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
		handler(data);
	}];
}

@end
