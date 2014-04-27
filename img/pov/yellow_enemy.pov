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

light_source{ <1, 1, -6> White  }



object
{
  difference
  {
	object{ Cube }
	
	object
	{
	  Sphere
                            
	  translate<+1, 0, 0>
	}
        
	object
	{
	  Sphere
            
	  translate<-1, 0, 0>
	}            
  }         
  
  scale 1.3
        
  material{M_Glass}
  finish{brilliance 1.0 specular 0.5  irid{0.4 thickness 0.2 turbulence 1.0} }  
}