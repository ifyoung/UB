
#import "CarHomeAnnotaton.h"
#import "CarAnnotationModel.h"

@implementation CarHomeAnnotaton

- (void)setCarmodel:(CarAnnotationModel *)carmodel
{
    _carmodel = carmodel;
    
    self.coordinate = carmodel.coordinate;
}

@end
