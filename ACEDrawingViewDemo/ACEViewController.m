#import "ACEViewController.h"
#import "ACEDrawingView.h"
#import "Colorpicker.h"
#import <QuartzCore/QuartzCore.h>

#define kActionSheetColor       100
#define kActionSheetTool        101

#define degreesToRadians(x) (M_PI * x / 180.0)


@interface UIImage (VIUtil)

- (CGSize)sizeThatFits:(CGSize)size;

@end

@implementation UIImage (VIUtil)

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize imageSize = CGSizeMake(self.size.width / self.scale,
                                  self.size.height / self.scale);
    
    CGFloat widthRatio = imageSize.width / size.width;
    CGFloat heightRatio = imageSize.height / size.height;
    
    if (widthRatio > heightRatio) {
        imageSize = CGSizeMake(imageSize.width / widthRatio, imageSize.height / widthRatio);
    } else {
        imageSize = CGSizeMake(imageSize.width / heightRatio, imageSize.height / heightRatio);
    }
    
    return imageSize;
}

@end

@interface UIImageView (VIUtil)

- (CGSize)contentSize;

@end

@implementation UIImageView (VIUtil)

- (CGSize)contentSize
{
    return [self.image sizeThatFits:self.bounds.size];
}

@end

@interface ACEViewController ()<UIActionSheetDelegate, UIScrollViewDelegate, ACEDrawingViewDelegate>
@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@property (nonatomic) BOOL rotating;
@property (nonatomic) CGSize minSize;

@end

@implementation ACEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _picker = [Colorpicker new];
    
    [self addObservers];
    
    [self methodToChangeTheme:nil];

    /**
     * setup intial line Width and pen color here
     **/
    self.lineWidthSlider.maximumValue = 20;
    self.lineWidthSlider.minimumValue = 1;
    self.drawingView.lineWidth = 2;
    self.lineWidthSlider.value = self.drawingView.lineWidth;
//    [self.lineWidthSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    /**
     * Here i did setup default brush stroke
     **/
    [self selectBrush:self];
    
    self.scrollView.delegate = self;
    self.scrollView.bouncesZoom = YES;
    /**
     * It need atleast two touchs for zooming and draging the canvas
     **/
    [self.scrollView.panGestureRecognizer setMinimumNumberOfTouches:2];
    [self.scrollView.panGestureRecognizer setMaximumNumberOfTouches:2];
    /**
     * Here i did setting up max/min zoom level
     **/
    [self setMaxMinZoomScale];
    
    /**
     * Here i did setup all required gestures
     **/
    [self setupGestureRecognizer];
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    // set the delegate
    self.drawingView.delegate = self;
    
//    _imageView.image = [UIImage imageNamed:@"patriotism.jpg"];
    
    
    [self setupRotationNotification];

    [self.navigationController.navigationBar setHidden:YES];
    
}

- (void)methodToChangeTheme:(NSNotification *)notification
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"themeColor"]  isEqual: @"normal"]) {
        [self lightTheme];
    } else {
        [self darkTheme];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

- (void)updateButtonStatus
{
    self.undoButton.enabled = [self.drawingView canUndo];
    self.redoButton.enabled = [self.drawingView canRedo];
}

- (IBAction)takeScreenshot:(id)sender
{
    [self SaveFileWithName];
}

- (IBAction)shapesPopOver:(UIBarButtonItem *)sender {
    [self popOverShapes:@"shapes"];
}

- (IBAction)strokePopOver:(UIBarButtonItem *)sender {
    [self popOverShapes:@"Slider"];
}

- (IBAction)getImage:(UIBarButtonItem *)sender {
    UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
    pickerView.allowsEditing = YES;
    pickerView.delegate = self;
    [pickerView setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentModalViewController:pickerView animated:YES];

}

- (IBAction)settings:(UIBarButtonItem *)sender {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsTable"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controller];
    nav.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popover = nav.popoverPresentationController;
    controller.preferredContentSize = CGSizeMake(300, 400);
    popover.delegate = self;
    popover.barButtonItem = self.settingsOutlet;
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)saveDrawing:(UIBarButtonItem *)sender {
    NSString * message = @"Save Image";
    
    UIImage * image = self.drawingView.image;
    
    if (image != nil) {
        NSArray * shareItems = @[message, image];
        
        UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
        
        avc.popoverPresentationController.barButtonItem = self.saveOutlet;
        
        [self presentViewController:avc animated:YES completion:nil];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                       message:@"Draw Something to save"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}

- (IBAction)S:(UIBarButtonItem *)sender {
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissModalViewControllerAnimated:true];
    
    UIImage * img = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    
    
    UIGraphicsBeginImageContext(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height));
    [img drawInRect:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    //here is the scaled image which has been changed to the size specified
    UIGraphicsEndImageContext();
    
    _drawingView.contentMode = UIViewContentModeScaleAspectFit;
    
    _drawingView.clipsToBounds = YES;
    
    self.scrollView.frame = self.view.frame;
    
    [self.drawingView loadImage:newImage];
    
}


- (void) SaveFileWithName
{
    NSError *error;
    NSData *pngData = UIImagePNGRepresentation(_drawingView.image);
    UIImageWriteToSavedPhotosAlbum(_drawingView.image, nil, nil, nil);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
//    documentsPath = [documentsPath stringByAppendingPathComponent:@"/JobProgress"];
//    
//    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath])
//        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:&error];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"]; //Add the file name
    
     CGSize imageSize = _drawingView.image.size;
    
    NSLog(@"imageSize.width = %f,imageSize.height = %f",imageSize.width,imageSize.height);
    [pngData writeToFile:filePath atomically:YES];
    
//    [self GetFileWithName];
}

- (void) GetFileWithName
{
    NSString *workSpacePath=[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"image.png"];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:workSpacePath]];
    
    
    CGSize imageSize = image.size;
    
    NSLog(@"imageSize.width = %f,imageSize.height = %f",imageSize.width,imageSize.height);

//    _drawingView.backgroundImage = image;
    
    [self.drawingView loadImage:image];
}

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (IBAction)undo:(id)sender
{
    [self.drawingView undoLatestStep];
    [self updateButtonStatus];
}

- (IBAction)redo:(id)sender
{
    [self.drawingView redoLatestStep];
    [self updateButtonStatus];
}

- (IBAction)clear:(id)sender
{
    [self.drawingView clear];
    [self updateButtonStatus];
    [self selectBrush:self];
}

- (IBAction)selectEraser:(id)sender
{
    self.drawingView.drawTool = ACEDrawingToolTypeEraser;
    [self.BrushButton setEnabled:YES];
    [self.EraserButton setEnabled:NO];
}

- (IBAction)selectBrush:(id)sender
{
    self.drawingView.drawTool = ACEDrawingToolTypePen;
    [self.BrushButton setEnabled:NO];
    [self.EraserButton setEnabled:YES];
}


- (IBAction)showColorPicker
{
    [editingToolBar setHidden:YES];
}

- (IBAction)colorSelected:(id)sender
{
    UIColor *color;
    
    if ([sender tag] == 10)
    {
        color = [_picker colorWithHexString:@"000000"];
    }
    else if ([sender tag] == 11)
    {
        color = [_picker colorWithHexString:@"EE1C23"];
    }
    else if ([sender tag] == 12)
    {
        color = [_picker colorWithHexString:@"FFD203"];
    }
    else if ([sender tag] == 13)
    {
        color = [_picker colorWithHexString:@"0000FF"];
    }
    else if ([sender tag] == 14)
    {
        color = [_picker colorWithHexString:@"800080"];
    }
    else if ([sender tag] == 15)
    {
        color = [_picker colorWithHexString:@"008000"];
    }
    
    selectedColor.tintColor = color;
    self.drawingView.lineColor = color;
    
    [editingToolBar setHidden:NO];
}




#pragma mark - ACEDrawing View Delegate

- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;
{
    [self updateButtonStatus];
}


#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        if (actionSheet.tag == kActionSheetColor) {
            
            self.colorButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
            switch (buttonIndex) {
                case 0:
                    self.drawingView.lineColor = [UIColor blackColor];
                    break;
                    
                case 1:
                    self.drawingView.lineColor = [UIColor redColor];
                    break;
                    
                case 2:
                    self.drawingView.lineColor = [UIColor greenColor];
                    break;
                    
                case 3:
                    self.drawingView.lineColor = [UIColor blueColor];
                    break;
            }
            
        } else {
            
            self.toolButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
            switch (buttonIndex) {
//                case 0:
//                    self.drawingView.drawTool = ACEDrawingToolTypePen;
//                    break;
//                    
                case 0:
                    self.drawingView.drawTool = ACEDrawingToolTypeLine;
                    break;
                    
                case 1:
                    self.drawingView.drawTool = ACEDrawingToolTypeRectagleStroke;
                    break;
                    
                case 2:
                    self.drawingView.drawTool = ACEDrawingToolTypeRectagleFill;
                    break;
                    
                case 3:
                    self.drawingView.drawTool = ACEDrawingToolTypeEllipseStroke;
                    break;
                    
                case 4:
                    self.drawingView.drawTool = ACEDrawingToolTypeEllipseFill;
                    break;
                    
//                case 6:
//                    self.drawingView.drawTool = ACEDrawingToolTypeEraser;
////                    self.drawingView initWithFrame:<#(CGRect)#>
//                    break;
//                    
//                case 7:
//                    self.drawingView.drawTool = ACEDrawingToolTypeText;
//                    break;

                case 5:
                    self.drawingView.drawTool = ACEDrawingToolTypeMultilineText;
                    break;
            }
            
            // if eraser, disable color and alpha selection
            self.colorButton.enabled = self.alphaButton.enabled = buttonIndex != 6;
        }
    }
}

#pragma mark - Settings

- (IBAction)colorChange:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Selet a color"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Black", @"Red", @"Green", @"Blue", nil];
    
    [actionSheet setTag:kActionSheetColor];
    [actionSheet showInView:self.view];
}

- (IBAction)toolChange:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Selet a tool"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Line",
                                  @"Rect (Stroke)", @"Rect (Fill)",
                                  @"Ellipse (Stroke)", @"Ellipse (Fill)", @"Text (Multiline)",
                                  nil];
    
    /*@"Pen", @"Line",
     @"Rect (Stroke)", @"Rect (Fill)",
     @"Ellipse (Stroke)", @"Ellipse (Fill)",
     @"Eraser", @"Text", @"Text (Multiline)"*/
    
    [actionSheet setTag:kActionSheetTool];
    [actionSheet showInView:self.view];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.containerView;
}

- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // The zoom rect is in the content view's coordinates.
    // At a zoom scale of 1.0, it would be the size of the
    // imageScrollView's bounds.
    // As the zoom scale decreases, so more content is visible,
    // the size of the rect grows.
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (IBAction)toggleWidthSlider:(id)sender
{
    // toggle the slider
    self.lineWidthSlider.hidden = !self.lineWidthSlider.hidden;
    [self.lineWidthSlider setValue:self.drawingView.lineWidth];
//    [self GetFileWithName];wi
    if (self.containerView.alpha == 1) {
        [self.containerView setAlpha:0.5];
        [self.drawingView setUserInteractionEnabled:NO];
    } else {
        [self.containerView setAlpha:1];
        [self.drawingView setUserInteractionEnabled:YES];
    }
    
}

- (IBAction)hideWidthSlider:(id)sender
{
    // toggle the slider
    self.lineWidthSlider.hidden = YES;
    
    //    [self GetFileWithName];
    [self.drawingView setUserInteractionEnabled:YES];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    self.drawingView.lineWidth = sender.value;
    NSLog(@"%f",self.drawingView.lineWidth);
}

- (IBAction)widthChange:(UISlider *)sender
{
//    NSLog(@"%d",self.lineWidthSlider.value);
//    self.drawingView.lineWidth = self.lineWidthSlider.value;
}

- (IBAction)toggleAlphaSlider:(id)sender
{
    // toggle the slider
    self.lineAlphaSlider.hidden = !self.lineAlphaSlider.hidden;
    self.lineWidthSlider.hidden = YES;
}

- (IBAction)alphaChange:(UISlider *)sender
{
    self.drawingView.lineAlpha = sender.value;
}

//- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.delegate = self;
//        self.bouncesZoom = YES;
//        
//        // Add container view
//        UIView *containerView = [[UIView alloc] initWithFrame:self.bounds];
//        containerView.backgroundColor = [UIColor clearColor];
//        [self addSubview:containerView];
//        _containerView = containerView;
//        
//        // Add image view
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
//        imageView.backgroundColor = [UIColor redColor];
//        imageView.contentMode = UIViewContentModeScaleToFill;
//        [containerView addSubview:imageView];
//        _imageView = imageView;
//        
//        
//        // Fit container view's size to image size
//        //        CGSize imageSize = imageView.contentSize;
//        //        self.containerView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
//        //        imageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
//        //        imageView.center = CGPointMake(containerView.frame.size.width / 2, containerView.frame.size.height / 2);
//        //
//        //        self.contentSize = imageSize;
//        //        self.minSize = imageSize;
//        
//        
//        [self setMaxMinZoomScale];
//        
//        // Center containerView by set insets
//        //        [self centerContent];
//        
//        // Setup other events
//        [self setupGestureRecognizer];
//        [self setupRotationNotification];
//    }
//    return self;
//}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    if (self.rotating) {
//        self.rotating = NO;
//        
//        // update container view frame
//        CGSize containerSize = self.containerView.frame.size;
//        BOOL containerSmallerThanSelf = (containerSize.width < CGRectGetWidth(self.bounds)) && (containerSize.height < CGRectGetHeight(self.bounds));
//        
//        CGSize imageSize = [self.imageView.image sizeThatFits:self.bounds.size];
//        CGFloat minZoomScale = imageSize.width / self.minSize.width;
//        self.minimumZoomScale = minZoomScale;
//        if (containerSmallerThanSelf || self.zoomScale == self.minimumZoomScale) { // 宽度或高度 都小于 self 的宽度和高度
//            self.zoomScale = minZoomScale;
//        }
//        
//        // Center container view
//        [self centerContent];
//    }
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Zooming related method
#pragma mark ************
#pragma mark - Setup 
#pragma mark ************

- (void)setupRotationNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)setupGestureRecognizer
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [_containerView addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerContent];
}

#pragma mark - GestureRecognizer

- (void)tapHandler:(UITapGestureRecognizer *)recognizer
{
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    } else if (self.scrollView.zoomScale < self.scrollView.maximumZoomScale) {
        CGPoint location = [recognizer locationInView:recognizer.view];
        CGRect zoomToRect = CGRectMake(0, 0, 50, 50);
        zoomToRect.origin = CGPointMake(location.x - CGRectGetWidth(zoomToRect)/2, location.y - CGRectGetHeight(zoomToRect)/2);
        [self.scrollView zoomToRect:zoomToRect animated:YES];
    }
}

#pragma mark - Notification

- (void)orientationChanged:(NSNotification *)notification
{
    self.rotating = YES;
}

#pragma mark - Helper

- (void)setMaxMinZoomScale
{
    CGSize imageSize = self.imageView.image.size;
    CGSize imagePresentationSize = self.imageView.contentSize;
    CGFloat maxScale = MAX(imageSize.height * 5 / imagePresentationSize.height * 5, imageSize.width / imagePresentationSize.width);
    self.scrollView.maximumZoomScale = MAX(1, maxScale); // Should not less than 1
    self.scrollView.minimumZoomScale = 1.0;
}

- (void)centerContent
{
    CGRect frame = self.containerView.frame;
    
    CGFloat top = 0, left = 0;
    if (self.scrollView.contentSize.width < self.scrollView.bounds.size.width) {
        left = (self.scrollView.bounds.size.width - self.scrollView.contentSize.width) * 0.5f;
    }
    if (self.scrollView.contentSize.height < self.scrollView.bounds.size.height) {
        top = (self.scrollView.bounds.size.height - self.scrollView.contentSize.height) * 0.5f;
    }
    
    top -= frame.origin.y;
    left -= frame.origin.x;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

#pragma-mark Pop Over Presentation

-(void) popOverShapes: (NSString*) storyBoardID
{
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:storyBoardID];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controller];
    controller.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popover = controller.popoverPresentationController;
    controller.preferredContentSize = CGSizeMake(300, 400);
    popover.delegate = self;
    if ([storyBoardID  isEqual: @"shapes"]) {
        popover.barButtonItem = _shapesOutlet;
    } else {
        popover.barButtonItem = _widthOutlet;
    }
    
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (void)shareText
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    [sharingItems addObject:@"www.google.com"];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    activityController.popoverPresentationController.barButtonItem = self.settingsOutlet;
    [self presentViewController:activityController animated:YES completion:nil];
    
}
-(void) addObservers{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(methodToChangeTheme:)
                                                 name:@"ThemeChanged"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shareText)
                                                 name:@"shareApp"
                                               object:nil];
    
}
-(void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:@"ThemeChanged"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"shareApp"];
}
-(void)darkTheme {
    [[self.navigationController navigationBar] setBarTintColor:[UIColor darkGrayColor]];
    [self.upperToolbar setBarTintColor:[UIColor darkGrayColor]];
    [editingToolBar setBarTintColor:[UIColor darkGrayColor]];
    [self.clearAllOutlet setTintColor:[UIColor whiteColor]];
    [self.settingsOutlet setTintColor:[UIColor whiteColor]];
    [self.toolChangeOutlet setTintColor:[UIColor whiteColor]];
    [self.undoButton setTintColor:[UIColor whiteColor]];
    [self.cameraOutlet setTintColor:[UIColor whiteColor]];
    [self.undoButton setTintColor:[UIColor whiteColor]];
    [self.redoButton setTintColor:[UIColor whiteColor]];
    [self.widthSliderOutlet setTintColor:[UIColor whiteColor]];
    [self.colorButton setTintColor:[UIColor whiteColor]];
    [self.EraserButton setTintColor:[UIColor whiteColor]];
    [self.BrushButton setTintColor:[UIColor whiteColor]];
    [self.saveOutlet setTintColor:[UIColor whiteColor]];
}
-(void)lightTheme {
    [[self.navigationController navigationBar] setBarTintColor:[UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:1]];
    [self.upperToolbar setBarTintColor:[UIColor lightGrayColor]];
    [editingToolBar setBarTintColor:[UIColor lightGrayColor]];
    [self.clearAllOutlet setTintColor:[UIColor blackColor]];
    [self.settingsOutlet setTintColor:[UIColor blackColor]];
    [self.toolChangeOutlet setTintColor:[UIColor blackColor]];
    [self.cameraOutlet setTintColor:[UIColor blackColor]];
    [self.undoButton setTintColor:[UIColor blackColor]];
    [self.redoButton setTintColor:[UIColor blackColor]];
    [self.widthSliderOutlet setTintColor:[UIColor blackColor]];
    [self.colorButton setTintColor:[UIColor blackColor]];
    [self.EraserButton setTintColor:[UIColor blackColor]];
    [self.BrushButton setTintColor:[UIColor blackColor]];
    [self.saveOutlet setTintColor:[UIColor blackColor]];
}

@end
