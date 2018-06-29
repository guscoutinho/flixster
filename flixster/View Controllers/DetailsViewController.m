//
//  DetailsViewController.m
//  flixster
//
//  Created by Gustavo Coutinho on 6/28/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TrailerViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseLabel;
@property (strong, nonatomic) IBOutlet UIView *tableView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    // NSUR is an object representing the location of a resource that bridges to URL
    NSURL *posterURL = [NSURL URLWithString: fullPosterURLString];
    [self.posterLabel setImageWithURL:posterURL];
    
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    NSURL *backdropURL = [NSURL URLWithString: fullBackdropURLString];
    [self.backdropView setImageWithURL:backdropURL];
    
    self.titleLabel.text = self.movie[@"title"];
    self.descriptionLabel.text = self.movie[@"overview"];
    self.releaseLabel.text = self.movie[@"release_date"];
                              
                              
    [self.titleLabel sizeToFit];
    [self.releaseLabel sizeToFit];
    [self.descriptionLabel sizeToFit];
    


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
//    NSIndexPath *indexPath = [self indexPathForCell:posterLabel];

    // Get the new view controller using [segue DetailsViewController].
    TrailerViewController *traillerViewController = [segue destinationViewController];
    
    // Pass the selected object to the new view controller.
    traillerViewController.movieSpecs = [self.movie[@"id"] stringValue];
    

}





@end
