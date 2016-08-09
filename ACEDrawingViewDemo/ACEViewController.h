#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class Colorpicker;
@class ACEDrawingView;

@interface ACEViewController : UIViewController<UIPopoverPresentationControllerDelegate,UIImagePickerControllerDelegate>
{
    __weak IBOutlet UIToolbar *
    editingToolBar;
    __weak IBOutlet UIBarButtonItem *selectedColor;
    __weak IBOutlet UIView *brushStrokeSliderBV;
    CAShapeLayer *circleLayer;
    
    CGRect drawingViewFrame;
    
    BOOL run;
    
}

@property (nonatomic,strong) Colorpicker *picker;

@property (nonatomic, unsafe_unretained) IBOutlet ACEDrawingView *drawingView;

//@property (nonatomic, unsafe_unretained) IBOutlet ACEDrawingView *drawingView;
@property (nonatomic, unsafe_unretained) IBOutlet UISlider *lineWidthSlider;
@property (nonatomic, unsafe_unretained) IBOutlet UISlider *lineAlphaSlider;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *previewImageView;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *undoButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *redoButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *colorButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *toolButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *alphaButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *BrushButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *EraserButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shapesOutlet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *widthOutlet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsOutlet;
@property (weak, nonatomic) IBOutlet UIToolbar *upperToolbar;
@property (weak, nonatomic) IBOutlet UIToolbar *colorToolbar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearAllOutlet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolChangeOutlet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraOutlet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *widthSliderOutlet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveOutlet;



@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

// actions
- (IBAction)undo:(id)sender;
- (IBAction)redo:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)takeScreenshot:(id)sender;
- (IBAction)shapesPopOver:(UIBarButtonItem *)sender;
- (IBAction)strokePopOver:(UIBarButtonItem *)sender;
- (IBAction)getImage:(UIBarButtonItem *)sender;
- (IBAction)settings:(UIBarButtonItem *)sender;
- (IBAction)saveDrawing:(UIBarButtonItem *)sender;
- (IBAction)getImageFromGallery:(UIBarButtonItem *)sender;

// settings
- (IBAction)colorChange:(id)sender;
- (IBAction)toolChange:(id)sender;
- (IBAction)toggleWidthSlider:(id)sender;
- (IBAction)widthChange:(UISlider *)sender;
- (IBAction)toggleAlphaSlider:(id)sender;
- (IBAction)alphaChange:(UISlider *)sender;

@end
