#include "colors.inc"
#include "shapes.inc"
#include "textures.inc"
#include "Woods.inc"
#include "stones.inc"
#include "glass.inc"
#include "metals.inc"


background{ rgbt<1.0, 1.0, 0.0> }

camera
{
    location <0, 0, -10>
    look_at <0, 0, 0>    
}

light_source{ <1, 1, -6> White  }



object
{
    Cube
                 
    
    scale 0.45
        
    
    material{M_Yellow_Glass} 
    finish{ ambient 0.2 phong 0.3}
}