//
//  ProfileViewController.m
//  Instagram
//
//  Created by jacquelinejou on 6/27/22.
//

#import "ProfileViewController.h"
#import "PhotoCell.h"
#import <Parse/Parse.h>
#import "Post.h"
#import "MBProgressHUD.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *postArray;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *changeProfPicButton;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"Profile";
    self.collectionView.dataSource = self;
    // load posts
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    [query orderByDescending:@"createdAt"];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.postArray = (NSMutableArray *)posts;
            [self.collectionView reloadData];
        }
    }];
    [[PFUser currentUser][@"profilePicture"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        self.profileImage.image = [UIImage imageNamed:@"placeholder.png"]; // placeholder image
        self.profileImage.image = [UIImage imageWithData:data];
    }];
    
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    Post *post = self.postArray[indexPath.row];
    [post.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        cell.postImage.image = [UIImage imageNamed:@"placeholder.png"]; // placeholder image
        cell.postImage.image = [UIImage imageWithData:data];
        cell.userInteractionEnabled = YES;
    }];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.postArray.count;
}

- (IBAction)changeProfilePicture:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.profileImage.image = editedImage;
    self.profileImage.image = [self resizeImage:editedImage withSize:CGSizeMake(self.profileImage.image.size.height, self.profileImage.image.size.width)];
    [self dismissViewControllerAnimated:YES completion:nil];
    self.changeProfPicButton.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    PFUser *user = [PFUser currentUser];
    user[@"profilePicture"] = [self getPFFileFromImage:self.profileImage.image];
    [user saveInBackground];
    [MBProgressHUD hideHUDForView:self.view animated:true];
    self.changeProfPicButton.enabled = YES;
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
