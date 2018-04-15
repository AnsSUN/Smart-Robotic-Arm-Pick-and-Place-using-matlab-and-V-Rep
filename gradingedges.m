function [Ie1]=gradingedges(Ie,Tl,Th)

[a b]=size(Ie);
Ie1=zeros([a b]);
for i=1:a
    for j=1:b
        if(Ie(i,j)>Th)
             Ie1(i,j)=Ie(i,j);
        elseif (Tl<Ie(i,j))&&(Ie(i,j)<Th)
                Ie1(i,j)=Ie(i,j);
        end
    end
end

