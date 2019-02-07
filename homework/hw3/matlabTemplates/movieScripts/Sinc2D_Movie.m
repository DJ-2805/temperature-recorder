%%
% Sinc2D_Movie.m
%
%JMA 11.29.18
%
%Loop driven screen movie of translating Cardinal Sine functions

%cardinal sine (sinc) function, f1 = sin(mx)/mx on x = -pi:dx:pi,  
%with dx ~ 0.02 and m = 8.
%
%Here plot this using x_trans = x - i*max(x)/numstep in a loop 
%over i = 0:numstep.  This produces an x value that "translates". 
%The 0-value of x moves to the right edge of the plot over  
%the loop.  The higher numstep, the more steps it takes to 
%translate across the screen.

%%
% SET UP
clc; clear all; close all; 


%DEFINE x vector
dx = 0.01; 
x = [-pi:dx:pi];

%anonymous cardinal sine fcn: 
func1 = @ (n,q) sin(n*q)./(n*q);
    %remember: n and q are proxy variables...

%Open Figure
fig1 = figure(1);
set(fig1, 'color', 'white'); 
set(fig1, 'position', [1000 800 800 600]);


%%
% OPEN VIDEO: 
%FIGURE OUT HOW TO TURN ON mp4!!!!: 
vid1 = VideoWriter('Sinc2D_Movie', 'MPEG-4'); 
open(vid1); 


%%
% DEFINE CONSTANTS: 
    numstep = 100; 
    m = 8; 
    wait = 0.001; 

%%    
% Loop 
for i = 0:numstep
    
    %Calculate x translations each time thru loop: 
    x_pos_trans = x - i*max(x)/numstep; 
    x_neg_trans = x + i*max(x)/numstep; 
    
    %Calculates positive and negative translating sinc functions:
    y_pos       = func1(m, x_pos_trans); 
    y_neg       = func1(m, x_neg_trans);  
    
    %PLOT!:
        %POS-ITIVELY TRANSLATING FUNCTION
        plot(x,y_pos, '-g','linewidth', 2.01)      
        xlabel('X'); ylabel('Y');
        axis([-pi pi -0.25 1.15])
        grid on
        
        %NEG-ATIVELY TRANSLATING FUNCTION
        hold on
        plot(x,y_neg, '-r','linewidth', 2.01)
           
    %Title Counter: 
        textstring = ['Step ' num2str(i, '%4i') ' of ' ...
            num2str(numstep, '%4i') '; Pause = ' ...
            num2str(wait, '%1.3f') ' sec']; 
        title(textstring, 'fontsize', 12)
        
    %Legend
        legend('Positive Sinc', 'Negative Sinc', 'location', 'northeast')

    %%
    % MOVIE WRITING WITHIN LOOP
    %SAVE FRAME FOR MOVIE
        frame = getframe(gcf); 
    %WRITE FRAME TO MOVIE
        writeVideo(vid1,frame);
        
    %%    
    % SCREEN Movie Speed (frames per second)
        %Stops loop for wait seconds; controls fps of screen movie 
        pause(wait); 
        
    %hold off so you get new lines next time through the loop!
        hold off
        %What happens if you dont do hold off here?!!? 
    
end

%%
% CLOSE VIDEO: 
    close(vid1); 

