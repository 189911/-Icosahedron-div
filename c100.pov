// Libraries containing color, texture, vector operations
#include "colors.inc"
#include "shapes.inc"
#include "math.inc" 
//--------abrimos archivo de entrada---------------
#fopen Myfile_entrada "4-icosaedro.xyz" read


//----leemos coordeandas de icosaedro y las guardamos en un arreglo----- 
#declare ico=array[12];  
//------------bloque para leer coordenadas de icosaedro----------------
#for (i,0,11,1)
  #read (Myfile_entrada, x0,y0,z0)
  #declare ico[i]=<x0,y0,z0>; 
  #end      
//-----------vamos a calcular la distancia minima entre cada atomo del icosaedro------------------
#declare minimo=1000;
#for (i,1,11,1) 
  #if (VDist(ico[0],ico[i])<minimo) 
    #declare minimo=VDist(ico[0],ico[i]);
    #end  
  #end  
//-----teniendo la distancia del minimo ahora podemos seleccionar nuestras aristas-------------- 
#declare N=4;
#declare Arista= array[30][2+N]; 
#declare n=0;
#while (n<30)
  #declare Arista[n][0]=<1000,10000,1000>; 
  #declare Arista[n][1]=<1000,10000,1000>;
  #declare Arista[n][2]=<1000,10000,1000>;
    
  #declare n=n+1;
  #end 
#declare s=0;
  #for(j,0,10,1)
    #for(i,j+1,11,1)
      #if ((VDist(ico[j],ico[i])<(minimo+0.1))&(VDist(ico[j],ico[i])>(minimo-0.1)))  
    //----------------------------asegurarnos de que no se repita-----------------------------                                             
   //-------------------------------------------------------------------------------------------  
          #declare Arista[s][0]=ico[j]; 
          #declare Arista[s][1]=ico[i];
          #declare Arista[s][1+N]=(ico[i]+ico[j])/2;
          #for (h,2,N,1)  
            #declare Arista[s][h]=Arista[s][1]+(h-1)*(Arista[s][0]-Arista[s][1])/N; 
            #end
          #declare s=s+1;
        #end
      #end  
    #end 
//-----------------------------------------------------------------------

//---------definimos el numero N para las diviciones oviamente tiene que ser mayor a cero

#declare caras=array[10000];
#declare caras2=array[10000];
#declare f=0;    
#declare delta=0.001;
#for(i,0,29,1) 
  #for(s,i+1,29,1)
    #if (VDist(Arista[i][1+N],Arista[s][1+N])<minimo/2+0.02)
      #for(j,2,N,1)
        #for(h,2,N,1) 
          #for(mil,2,N-1,1) 
            #if ((VDist(Arista[i][j],Arista[s][h])>mil*minimo/N-delta)&(VDist(Arista[i][j],Arista[s][h])<mil*minimo/N+delta))
              #declare beta=1; 
              #while (beta<mil)
                #declare caras[f]=Arista[i][j]+beta*(Arista[s][h]-Arista[i][j])/mil;
                #declare f=f+1;
                #declare beta=beta+1;
                #end
              #end 
            #end
          #end
        #end
      #end  
    #end
  #end
      
#declare caras2[0]=caras[0];
#declare contador2=1;
#declare zeta=0;
#for (i,1,f-1,1)
  #declare ata=1; 
  #for(s,0,contador2-1,1)
    #if (VDist(caras2[s],caras[i])<delta)
      #declare ata=0;
      #end
    #end  
  #if (ata=1)
    #declare caras2[contador2]=caras[i];
    #declare contador2=contador2+1;   
    #end 
  #end 

//------------------------------------------------------------
  
#fopen Myfile_Avogadro "Coordenadas_Avogadro.xyz" write 
#write(Myfile_Avogadro,12+(N-1)*30+contador2,"\n")
#write(Myfile_Avogadro,"\n")
#for (i,0,contador2-1,1)
    #write (Myfile_Avogadro, "AU  ",vstr(3, caras2[i],   " ",  0,3), "\n")   
  #end
#for (i,0,29,1)
  #for(j,2,N,1)
    #write (Myfile_Avogadro, "Au  ",vstr(3, Arista[i][j],   " ",  0,3), "\n")
    //#sphere{ c100[i],  0.15 pigment{color Red}}    
    #end
  #end    
#for(j,0,11,1)
    #write (Myfile_Avogadro, "Au  ",vstr(3, ico[j],   " ",  0,3), "\n")   
    #end
