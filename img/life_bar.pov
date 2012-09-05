#include "colors.inc"
#include "shapes.inc"
#include "textures.inc"
#include "Woods.inc"
#include "stones.inc"
#include "glass.inc"
#include "metals.inc"


background{ rgbt<1.0, 0.0, 0.0, 0.0> }

camera
{
    location <0, 0, -10>
    look_at <0, 0, 0>    
}

light_source{ <+3, +2, -5> White  }
light_source{ <-3, -2, -5> White  }

object
{
    Cube

    scale<1.0, 1.0, 0.1>
    
                  
    material { texture { pigment { color Clear } finish { F_Glass1 } } interior { I_Glass1 fade_color Col_Red_01 } }
}