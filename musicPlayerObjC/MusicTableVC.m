//
//  MusicTableVC.m
//  musicPlayerObjC
//
//  Created by Руслан Ольховка on 29.12.15.
//  Copyright © 2015 Руслан Ольховка. All rights reserved.
//

#import "MusicTableVC.h"
#import "Song.h"

@interface MusicTableVC () {
	NSMutableArray* songs;
}
@end

@implementation MusicTableVC


- (void)viewDidLoad {
    [super viewDidLoad];
	
	songs = [[NSMutableArray alloc] init];
	[self getSongs];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getSongs {
	NSURL *url = [[NSURL alloc] initWithString:@"https://api-content-beeline.intech-global.com/public/marketplaces/1/tags/10/melodies"];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	[NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
		NSError *error = nil;
		NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
		if (error) {
			NSLog(@"error %@", error.localizedDescription);
		} else {
			[self extractJSON:[json objectForKey:@"melodies"]];
		}
	}];
}

- (void)extractJSON:(NSDictionary*)json {
	NSEnumerator *enumerator = [json objectEnumerator];
	NSDictionary *melody;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < songs.count) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songCell" forIndexPath:indexPath];
		
		Song *song = [songs objectAtIndex:indexPath.row];
		
		cell.textLabel.text = song.title;
		cell.detailTextLabel.text = song.artist;
		
		return cell;
	} else {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadingCell" forIndexPath:indexPath];
		return cell;
	}
	
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
