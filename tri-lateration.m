clc;
clear;
close all;

%----------------------Trilateration Calculator--------------------------
  x1 = input('input x1 co-ordinate: ');
  y1 = input('input y1 co-ordinate: ');
  x2 = input('input x2 co-ordinate: ');
  y2 = input('input y2 co-ordinate: ');
  x3 = input('input x3 co-ordinate: ');
  y3 = input('input y3 co-ordinate: ');
  
  r1 = input('input distance to point 1: ');
  r2 = input('input distance to point 2: ');
  r3 = input('input distance to point 3 : ');
  
  
  matxi = [((r1^2 - r2^2)-(x1^2 -x2^2)-(y1^2 - y2^2)) 2*(y2-y1) ; ((r1^2 - r3^2)-(x1^2 -x3^2)-(y1^2 - y3^2)) 2*(y3-y1)];
  matxb = [2*(x2- x1) 2*(y2-y1) ; 2*(x3 - x1) 2*(y3-y1)];
  
  matyi = [2*(x2-x1) ((r1^2 - r2^2)-(x1^2 - x2^2)-(y1^2 - y2^2)) ; 2*(x3 - x1) ((r1^2 - r3^2)-(x1^2 - x3^2)-(y1^2 - y3^2))];
  matyb = [2*(x2 - x1) 2*(y2 - y1) ; 2*(x3 - x1) 2*(y3 - y1)];
  
  PtX = (det(matxi)/det(matxb))
  PtY = (det(matyi)/det(matyb))
  
  
 displayx = strcat('X coordinate := ', num2str(PtX));
 displayy = strcat('Y coordinate := ', num2str(PtY));
 
 disp(displayx);
 disp(displayy);
