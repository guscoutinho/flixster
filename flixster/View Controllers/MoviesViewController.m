//
//  MoviesViewController.m
//  flixster
//
//  Created by Gustavo Coutinho on 6/27/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

// Implements protocols
@interface MoviesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Table View expects a data source
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Start the activity indicator
    [self.activityIndicator startAnimating];

    
    // Do any additional setup after loading the view.
    [self fetchMovies];
    
    // Instatiates refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    // Programagtic view of dragging and dropping in code
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    
    // Nests views into subviews
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect the row which was tapped
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) fetchMovies {
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            
            // Instatiate the UIAlertController
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
                                                                           message:@"The internet connections seems to be offline"
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            
            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 [self fetchMovies];
                                                                 
                                                             }];
            
            // add the OK action to the alert controller
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{
                // optional interface
            }];
            
            
            
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            // Gets the array of movies & store the movies in a property to use elsewhere
            self.movies = dataDictionary[@"results"];
            
            
            // Reloads your table view data
            [self.tableView reloadData];
            
        }
        [self.refreshControl endRefreshing];
        
        // Stop the activity indicator
        // Hides automatically if "Hides When Stopped" is enabled
        [self.activityIndicator stopAnimating];
    }];
    [task resume];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Dynamically alocates the number of movies
    return self.movies.count;
}

// UITableView expects to be a cell; has more accessories than a regular view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Creates template for MovieCell--the movie poster and description; reusable because of memory allocation & dequeue cell
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    // Associates movies with rows
    NSDictionary *movie = self.movies[indexPath.row];
    
    // Updates cell with mvoie data
    cell.titleLabel.text = movie[@"title"];
    cell.descriptionLabel.text = movie[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    // NSUR is an object representing the location of a resource that bridges to URL
    NSURL *posterURL = [NSURL URLWithString: fullPosterURLString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:posterURL];

    
    // Avoids showing the poster from the 'old' movie when the user scrolls down too fast
//    cell.posterView.image = nil;
    
    [cell.posterView setImageWithURLRequest:request placeholderImage:nil
                                    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                        
                                        
                                        
                                        
                                        // imageResponse will be nil if the image is cached
                                        if (imageResponse) {
                                            NSLog(@"Image was NOT cached, fade in image");
                                            cell.posterView.alpha = 0.0;
                                            cell.posterView.image = image;
                                            
                                            //Animate UIImageView back to alpha 1 over 0.3sec
                                            [UIView animateWithDuration:0.3 animations:^{
                                                cell.posterView.alpha = 1.0;
                                            }];
                                        }
                                        else {
                                            NSLog(@"Image was cached so just update the image");
                                            cell.posterView.image = image;
                                        }
                                    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                        // do something for the failure condition
                                    }];
    
        
    // Returns the cell to the table view
    return cell;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UITableView *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    
    // Get the new view controller using [segue DetailsViewController].
    DetailsViewController *detailsViewController = [segue destinationViewController];
    
    // Pass the selected object to the new view controller.
    detailsViewController.movie = movie;
    
}


@end
