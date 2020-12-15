function result =  Minkowskis_distance_equation(X1,X2,Y1,Y2)
p=2;
result  = sum(abs(abs(X1-Y1)+abs(X2-Y2)).^p).^(1/p);