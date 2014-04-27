#include "colors.inc"
#include "shapes.inc"
#include "textures.inc"
#include "Woods.inc"
#include "stones.inc"
#include "glass.inc"
#include "metals.inc"


background{ rgbt<1.0, 1.0, 0.0, 0.0> }

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
        object
        { 
        	Cube
       
       		rotate<0, 0, 45>
                                     	
      	}
        
        object
        {
            Sphere
                                
            scale<0.5, 1.0, 2.0>
            translate<+1, -1, 0>
        }
        
        object
        {
            Sphere
            
            scale<0.5, 1.0, 2.0>
            translate<-1, -1, 0>
        }
        
	}       
              
    scale<0.6, 1, 1>
    scale 1.5                 
  
  	material { texture { pigment { color Clear } finish { F_Glass1 } } interior { I_Glass1 fade_color Col_Fluorite_07 } } 
    finish{ ambient 0.2 phong 0.3 }                                                                                     
}