//
//  ComposeViewController.m
//  Instagram
//
//  Created by jacquelinejou on 6/27/22.
//

#import "ComposeViewController.h"
#import "Post.h"
#import "MBProgressHUD.h"

@interface ComposeViewController ()

@property (weak, nonatomic) NSDictionary *dataDictionary;
@property (nonatomic, strong) Post *post;
@property (weak, nonatomic) IBOutlet UITextView *captionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (strong, nonatomic) UIImage *resizedImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.post.caption = self.captionLabel.text;
    self.resizedImage = [[UIImage alloc] init];
}

- (IBAction)selectImages:(id)sender {
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
    self.postImage.image = editedImage;
    self.resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(self.postImage.image.size.height, self.postImage.image.size.width)];
    [self dismissViewControllerAnimated:YES completion:nil];
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

// Add a loading sign while request is going on
- (IBAction)didTapShare:(id)sender {
    self.shareButton.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [Post postUserImage:self.resizedImage withCaption:self.captionLabel.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(!error){
            [self.delegate loadMoreData:20];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error Posting" message:@"Please retry." preferredStyle:(UIAlertControllerStyleAlert)];
            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                handler:^(UIAlertAction * _Nonnull action) {
            }];
            // add the OK action to the alert controller
            [alert addAction:okAction];
        }
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [self dismissViewControllerAnimated:YES completion:nil];
        self.shareButton.enabled = YES;
    }];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
