function T =calc_std (List)
for i=1:size(List,1)
    T(i)=mean(List(i,:));
end
