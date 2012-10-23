#include "colors.inc"
#include "shapes.inc"
#include "textures.inc"
#include "Woods.inc"
#include "stones.inc"
#include "glass.inc"
#include "metals.inc"


background{ rgbt<1.0, 1.0, 1.0, 0.0> }

camera
{
    location <0, 0, -10>
    look_at <0, 0, 0>    
}

light_source{ <3, 2, -5> White  }


object{
  difference
  {
	object{ Sphere }
	
	object
	{
	  Cube
	  
	  translate<0, 0, -1>
	}
	
	object
	{
	  Sphere
	  
	  scale<0.3, 0.3, 1>
	}
  }
            
  scale 1.8
    
  material{M_Glass}
  finish{brilliance 1.0 specular 0.5  irid{0.4 thickness 0.2 turbulence 1.0} }
}