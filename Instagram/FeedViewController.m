//
//  FeedViewController.m
//  Instagram
//
//  Created by mattpdl on 7/6/21.
//

#import "FeedViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "PostCell.h"
#import "SceneDelegate.h"

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Post *> *posts;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.user = PFUser.currentUser;
    [self fetchPosts];
    
    // Add refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Logged out %@", self.user.username);
            
            // Redirect to login screen
            SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginScreen = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            sceneDelegate.window.rootViewController = loginScreen;
        }
    }];
}

- (void)fetchPosts {
    // Construct PFQuery for posts
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;

    // Fetch posts asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            // Store posts array and reload table view
            NSLog(@"Fetched posts for %@", self.user.username);
            self.posts = posts;
            [self.tableView reloadData];
        }
        else {
            // Print error
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    // Fetch new posts and reload table view
    [self fetchPosts];

    // Tell the refreshControl to stop spinning
    [refreshControl endRefreshing];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // Dequeue PostCell and set post labels and image
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    [cell setPost:self.posts[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MIN(self.posts.count, 20);
}

@end
