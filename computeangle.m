function [theta]=computeangle(IGradX,IGradY)
[a,b]=size(IGradX);
theta=zeros([a b]);
for i=1:a
      for j=1:b
            if(IGradX(i,j)==0)
               theta(i,j)=atan(IGradY(i,j)/0.000000000001);
            else
                theta(i,j)=atan(IGradY(i,j)/IGradX(i,j));
            end
      end
 end
  theta=theta*(180/3.14);
  for i=1:a
      for j=1:b
            if(theta(i,j)<0)
               theta(i,j)= theta(i,j)-90;
            theta(i,j)=abs(theta(i,j));
            end
      end
 end
  for i=1:a
      for j=1:b
          if ((0<theta(i,j))&&(theta(i,j)<22.5))||((157.5<theta(i,j))&&(theta(i,j)<181))
                theta(i,j)=0;
          elseif (22.5<theta(i,j))&&(theta(i,j)<67.5)
                 theta(i,j)=45;
          elseif (67.5<theta(i,j))&&(theta(i,j)<112.5)  
                  theta(i,j)=90;
          elseif (112.5<theta(i,j))&&(theta(i,j)<157.5)
                  theta(i,j)=135;
          end
      end
  end 