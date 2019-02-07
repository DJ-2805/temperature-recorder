%Sinc3D_Movie.m
%
%JMA 12.4.17
%
%Loop driven screen movie of translating 3D RADIAL Cardinal Sine 

%Radial Sinc function, RSinc = sin(m*R)/m*R on x = -pi:dx:pi, 
%y = -pi:dy:pi, and R = sqrt(x^2 + y^2), 
%with dx = dy = 0.03 and m = 3.
%
%Here plot this using x_trans = x - i*max(x)/numstep in a loop 
%over i = 0:numstep.  This creates an translating x-vector. 
%The 0-value of x moves to the right edge of the plot over  
%the loop.  The higher numstep, the more steps it takes to 
%translate across the screen.

%SET UP
clc; clear all; close all; 


%DEFINE x vector
dx = 0.05; 
x = [-pi:dx:pi];
y = x; 

%MESHGRID ARRAYS FOR XX, YY: 
[XX, YY] = meshgrid(x,y);
    %CREATES 2D MATRICES (length(x), length(y)) with all  
    %x values in XX, and all the y values in YY.   
    %Then you can use thesefor 2D E-by-E calculations, 
    %as shown below: 

%anonymous cardinal sine fcn: 
RSinc = @ (n,X,Y) sin(n*sqrt(X.^2 + Y.^2))./...
                     (n*sqrt(X.^2 + Y.^2));
    %NB: could have defined 2D matrix R(XX,YY) above, 
    %and then re-used func1 from Sinc2D_movie.m

%Open Figure
fig1 = figure(1);
set(fig1, 'position', [1000 800 1000 700])

%DEFINE CONSTANTS: 
    numstep = 100; 
    m = 3; 
    wait = 0.05; 

%Loop 
for i = 0:numstep
    
    %Calculate "translating x" each time thru loop: 
    XX_pos_trans = XX - i*max(x)/numstep; 
    
    %Calculates translating sinc function:
    ZZ           = RSinc(m, XX_pos_trans, YY); 
    
    %PLOT!:
        %3D Surface Plot:
        surf(XX, YY, ZZ);
        %VIEWING ANGLE (Azimuth and Elevation)
        view(-20, 30)
        %Labels:
        xlabel('X'); ylabel('Y'), zlabel('Z');
        %AXIS LIMITS
        axis([-pi pi -pi pi -0.25 1.25])
        grid on
        
    %Title Counter: 
        textstring = ['Step ' num2str(i, '%4i') ' of ' ...
            num2str(numstep, '%4i') '; Pause = ' ...
            num2str(wait, '%1.3f') ' sec']; 
        title(textstring, 'fontsize', 12)
  
    %Movie Speed (frames per second)
        %Stops loop for wait seconds; controls fps of screen movie 
        pause(wait); 
        
    %hold off so you get new lines next time through the loop!
        hold off
        %What happens if you dont do hold off here?!!? 
    
end

