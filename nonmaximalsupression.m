function [Isup]=nonmaximalsupression(I,theta)
[a1 b1]= size(theta);
Isup=zeros([a1 b1]);
 I = padarray(I, [1 1]);
 [a b]=size(theta);
for i=2:a-2
    for j=2:b-2
      
           if (theta(i,j)==135)
                 if ((I(i-1,j+1)>I(i,j))||(I(i+1,j-1)>I(i,j)))
                      I(i,j)=0;
                  end
           elseif (theta(i,j)==45)   
                  if ((I(i+1,j+1)>I(i,j))||(I(i-1,j-1)>I(i,j)))
                       I(i,j)=0;
                  end
           elseif (theta(i,j)==90)   
                  if ((I(i,j+1)>I(i,j))||(I(i,j-1)>I(i,j)))
                      I(i,j)=0;
                  end
           elseif (theta(i,j)==0)   
                  if ((I(i+1,j)>I(i,j))||(I(i-1,j)>I(i,j)))
                      I(i,j)=0;
                  end
           end
    end
end
Isup=I;

                   
            