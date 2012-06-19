#include "colors.inc"
#include "shapes.inc"
#include "textures.inc"
#include "Woods.inc"
#include "stones.inc"
#include "glass.inc"
#include "metals.inc"


background{ rgbt<1.0, 0.0, 0.0> }

camera
{
    location <0, 0, -10>
    look_at <0, 0, 0>    
}

light_source{ <3, 2, -5> White  }



object{
    Sphere                 
    
    scale 0.65
    
    
    material{M_Ruby_Glass} 
    finish{ ambient 0.55 } 
}