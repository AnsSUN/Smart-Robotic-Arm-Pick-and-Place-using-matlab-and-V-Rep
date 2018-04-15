function [IGradX, IGradY]= smoothing(I1)
mask= [2 4 5 4 2;
       4 9 12 9 4;
       5 12 15 12 5;
       4 9 12 9 4;
       2 4 5 4 2];
   mask=mask/115;
   Ismooth= conv2(I1,mask);
   gradXmask=[-1 0 1;
              -2 0 2; 
              -1 0 1];
  gradYmask=[1 2 1;
             0 0 0; 
            -1 -2 -1];
  IGradX= conv2(Ismooth,gradXmask);
  IGradY= conv2(Ismooth,gradYmask);
    