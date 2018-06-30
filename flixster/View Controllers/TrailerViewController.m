//
//  TrailerViewController.m
//  flixster
//
//  Created by Gustavo Coutinho on 6/28/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import "TrailerViewController.h"
#import <WebKit/WebKit.h>
#import "DetailsViewController.h"

@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webViewOutlet;

@property NSArray *returnResult;
@property NSString *thisMovieKey;

@end

@implementation TrailerViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self fetchTrailer];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void) fetchTrailer {
    
    NSString *firstPart = @"https://api.themoviedb.org/3/movie/";
    NSString *transition = [firstPart stringByAppendingString:self.movieSpecs];
    NSString *secondPart = @"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US";
    NSString *finalUrlString = [transition stringByAppendingString:secondPart];
    
    NSURL *url = [NSURL URLWithString:finalUrlString];
    
    
//    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/{movie_id}/videos?api_key=<<api_key>>&language=en-US"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
            self.returnResult = dataDictionary[@"results"];
            
            NSString *key = [self.returnResult firstObject][@"key"];
            
            NSString *youtubeURL = @"https://www.youtube.com/watch?v=";
            
            
            NSString *thisMovieTrailer = [youtubeURL stringByAppendingString:key];
            
            
            // Convert the url String to a NSURL object.
            NSURL *trailerUrl = [NSURL URLWithString:thisMovieTrailer];
            
            // Place the URL in a URL Request.
            NSURLRequest *request = [NSURLRequest requestWithURL:trailerUrl
                                                     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                 timeoutInterval:10.0];
            
            // Load Request into WebView.
            [self.webViewOutlet loadRequest:request];
            
            
            
            
        }
    }];
    [task resume];
    
}


@end
