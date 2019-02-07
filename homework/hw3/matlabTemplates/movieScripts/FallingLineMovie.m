%FallingLineMovie.m
%
%JMA 11.29.18
%
%Loop driven screen movie of some moving function

%Say a line: 
% y = mx + (b - i)
%
%Loop varies i value and shifts line up/down in time...

%SET UP
clc
clear all
close all

%DEFINE x, m and b
x = [-5:5];
m = 1; b = 0; 


%LINE COLORS: 
    %black line: 
    %clrvec = ['k'];
    %Colorful Lines: 
    clrvec = ['kbgyrcm']
    lnth_c = length(clrvec); 

%Open Figure
f1 = figure(1);

%Counter
    k = 0; 

%Loop 
for i = 0:0.25:10
    
    %Counter 
        k = k + 1; 
        
    %Color Counter: 
        q = 1 + mod(k,lnth_c)    %starts at 2nd color (T. Gilmore!)
    
    %Calculate line values:
        y = m*x + (b - i);           %vary y-intercept
        %y = (m/(1+i))*x + (b - i);   %vary slope & y-intercept
    
    %Plot    
        plot(x,y, ['-' clrvec(q)],'linewidth', 2.01)
        xlabel('X'); ylabel('Y');
        axis([-10 10 -15 15])
        grid on
        %hold on
           
    %Live Counter (--doesn't work with hold on): 
        textstring = ['Iteration k = ' num2str(k, '%4i')]; 
        text(-7.5, 7.5, textstring, 'fontsize', 16);

    %Movie Speed (frames per second)
        %Stops loop for wait seconds; controls fps of screen movie 
        wait = 0.05; 
        pause(wait);   
    
end

