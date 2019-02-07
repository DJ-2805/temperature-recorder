%UsingAnonFcn.m
%
%JMA 11/13/18

%USE AN ANONYMOUS FCN IN A SCRIPT...

setup_udf; 
clear; 

%define anonymous fcn: 
cardsine = @ (in, k) sin(k*in)./in ; 


x = [-3:0.001:3]; 
m = 10; 

y = cardsine(x,m);

plot(x,y,'-k')