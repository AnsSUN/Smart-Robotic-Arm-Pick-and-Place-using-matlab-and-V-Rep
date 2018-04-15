function [Ifinal]=connectingedge(Ie1,Th,Tl)
[a b]= size(Ie1);
Ifinal=zeros([a b]);
for i=1:a
    for j=1:b
        if (Ie1(i,j)>Th)
            Ifinal(i,j)=Ie1(i,j);
             for i2=(i-1):(i+1)
                 for j2= (j-1):(j+1)
                     if (Ie1(i2,j2)>Tl)&&(Ie1(i2,j2)<Th)
                         Ifinal(i2,j2)=Ie1(i,j);
                     end
                 end
              end
        end
   end
end
end

