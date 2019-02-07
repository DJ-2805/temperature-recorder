%Ex1_Nlinfit.m
%
%JMA 11/14/18
%

clear
clc
close all


%DATA: linear to 1, then goes flat

x_in = [0:0.25:2];
y_in = [0 0.3 0.46 0.774 1.03 1.01 0.96 1.07 1.02]; 
   
    %SAVE RAW TO GIVE TO CLASS
    %save Ex1_data.mat x_in y_in

    %PLOT RAW DATA
    plot(x_in, y_in, '+b', 'markersize', 12, 'linewidth', 2)




%THEORY SUGGESTS m=1 LINEAR to x=1, then flat lines to 2.

test_fcn = @(coef, x)  (coef(1)*x       + coef(2)).*(x <= coef(3)) ...
                      +(coef(1)*coef(3) + coef(2)).*(x >  coef(3));

	%NB: 
    %coef(3) is the X-INTERSECTION POINT (aka, x_break)
    %
    %(coef(1)*coef(3) + coef(2)) is the Y-INTERSECTION POINT 
	%between the two branches of the composite curve.
             

%m, b, xbreak                
guess_IN = [0.2 9 1.7]; 

%NLINFIT!: 
coef_OUT = nlinfit(x_in, y_in, test_fcn, guess_IN)

%OVERPLOT
hold on

%CREATED BEST FIT COMPOSITE CURVE
y_fit = test_fcn(coef_OUT, x_in);

plot(x_in, y_fit, '-k', 'linewidth', 2)


