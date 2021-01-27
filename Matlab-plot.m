 clear;
 clc;
 close all;
 
  disp('---------Final Year Project Mayur Ramjee--------------')
  A = dlmread('pos.txt',' ');
  Iloop = true;
  Tloop = true;
  while (Iloop);
      dime = input('2D or 3D graph to be displayed? : Please enter either 2 = 2D or 3 = 3D): ');
      if (dime == 2 || dime == 3)
          Iloop = false;
      end
      
  end
   
  
  if (dime == 2)
  while (Tloop)
   pL = input('Select plane: 1 = XY , 2 = XZ , 3 = YZ:  ');
   if (pL == 1 || pL == 2 || pL == 3)
       Tloop = false;
  end
  
  
  
  if (pL == 1)
      plot(A(:,1),A(:,2));
  end 
  
  if (pL == 2)
      plot(A(:,1),A(:,3));
  end
  
  if (pL == 3)
      plot(A(:,2),A(:,3));
  end
  end
  end
  
  if(dime == 3)
  plot3(A(:,1),A(:,2),A(:,3));
  end
  
