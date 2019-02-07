%MOR_CompositeFit.m
%
%  J. Aurnou 11/9/16
%
%     This matlab script reads in a Carlson n Johnson 1994 data set: MOR_data_w.mat. 
% 
%       Plots the three ridges MAR, EPR and CIR as three different color symbols.
%       Overplots a best depth vs. age^1/2 fit to all the compiled data 
%       with Ages <= tau AND fits a linear trend for all data > tau.
%       This is accomplished via an nlinfit procedure, which best fits both curves as well the value of t_break.
%



%%%%%%%%%%%%%%%%%%%
%CLEAN UP THE WORKSPACE
%%%%%%%%%%%%%%%%%%%

    clear           %clears all open variables
    clc             %clears the command window
    close all       %closes all open figure windows
    format shortE   %Engineering notation


%%%%%%%%%%%%%%%%%%%
%LOAD C&J DATA:  
%%%%%%%%%%%%%%%%%%%

    %LOAD DATA FILES: 
    load MOR_data_w.mat;   %file stored in directory DATA that within my current folder.
    
    %LOADS: Age (Ma), Depth (m), Ridge (cell) 
    %all are 61 x 1 arrays.

    %CONVERT DEPTH TO KILOMETERS
    Depth = Depth/1e3;
       
       
    %%%%%%%%%%%%%%%%%%%
    %RIDGE LV's: 
    %%%%%%%%%%%%%%%%%%%

        %Use string compare command (strcmp) to pick out the different 
        %ridge indices in cell array Ridge
        LV_MAR = strcmp('MAR', Ridge); 
        LV_EPR = strcmp('EPR', Ridge); 
        LV_CIR = strcmp('CIR', Ridge); 

   

%%%%%%%%%%%%%%%%%%%
%ANONYMOUS COMPOSITE RIDGE FUNCTION, RIDGE_CMPFCN: 
%%%%%%%%%%%%%%%%%%%
     
    %Anon Fcn: C = 1x4 coef array; t = age array
    Ridge_CmpFcn = @ (C, t)   (C(1).*sqrt( t  ) + C(2)).*(t <= C(3)) ...
                          + ( (C(1).*sqrt(C(3)) + C(2)) + C(4).*(t - C(3)) ).*(t > C(3)); 
                           
                      
       
    %fcn = (A.*t^1/2   + B).*(t<=tbreak) +         
           %%% t^1/2 law below t = tbreak %%%
    %    ( (A.*tbreak^1/2 + B) + C*.(t - tbreak) ).* (t > tbreak)   
           %%% linear (t - tbreak) law above t = tbreak %%%

    
    
%%%%%%%%%%%%%%%%%%%
%Best Fit to ridge_cmpfcn
%%%%%%%%%%%%%%%%%%%


        %%%%%%%%%%%%%%%%%%%
        %NLINFIT: 
        %%%%%%%%%%%%%%%%%%%

        C_IN  = [0.50 10 10 7];      %Guess Units: km/Ma^1/2 km Age km/Ma

        C_OUT = nlinfit(Age, Depth, Ridge_CmpFcn, C_IN);
            %GENERICALLY: BETA_FIT = nlinfit(X,Y, TEST_FCN, BETA0)
            
                
            %FOR PLOTTING SMOOTH FIT CURVES: 
                xsmooth = [0:0.1:max(Age)];                     %uber high res x-array
                ysmooth = Ridge_CmpFcn(C_OUT, xsmooth);         %corresponding high res best fit y-values

            
                
%%%%%%%%%%%%%%%%%%%
%PLOT: 
%%%%%%%%%%%%%%%%%%%
                   
    %OPEN FIGURE1
    fig1 = figure(1);
    %SET BACKGROUND WHITE
    set(fig1,'color','white');                    
    %SET CUSTOM IMAGE SIZE
    set(fig1, 'Position', [900, 900, 800, 500]); 
    
    
    %FONTSIZE VALUE
    fsize = 20;
    %LINEWIDTH
    lwidth = 2.51;
    %MARKER SIZE
    msize = 7.5;


    %PLOT MAR DATA:
    plot(Age(LV_MAR), Depth(LV_MAR),'sb', 'markersize', msize, 'markerfacecolor', 'b')
    set(gca, 'Ydir', 'reverse')
    set(gca, 'fontsize', 16)
    axis([-10 180 2.250 7.250])
    grid on
    hold on
    
    %PLOT LABELS: 
    xstr = 'Seafloor Age, t [Ma]';
    ystr = 'Bathymetric Depth [km]';
    titlestr = ['C&J94 Composite Best Fit; J. Aurnou, ' date];
%    xylabels(xstr, ystr, fsize);
    plotlabels(xstr, ystr, titlestr, fsize);
%    title(titlestr, 'fontsize', 0.75*fsize);
    
    %OVERPLOTS:
    %EPR DATA
    plot(Age(LV_EPR), Depth(LV_EPR),'or', 'markersize', msize, 'markerfacecolor', 'r')

    %CIR DATA
    plot(Age(LV_CIR), Depth(LV_CIR),'dg', 'markersize', msize, 'markerfacecolor', 'g')

    %NLINFIT to Ridge_CmpFcn:
    plot(xsmooth, ysmooth, '-k', 'linewidth', lwidth)
                        

            %LEGEND BOX
            hleg = legend('MAR Data', 'EPR Data', 'CIR Data', ...
                'Composite NLINFIT','location','NorthEast');
            set(hleg, 'fontsize', 0.75*fsize);
            
            %FIT STRINGS: 
            FITstr1 = 'Depth = (A*t^{1/2}   + B)*(t<=tau)';
            FITstr2 = '        + ( (A*tau^{1/2} + B) + C*(t - tau) )* (t > tau)';
            FITstr3 = ['A = ' num2str(C_OUT(1), '%1.2f') '; B = ' num2str(C_OUT(2), '%1.2f') ...
                        '; tau = ' num2str(C_OUT(3), '%2.1f') '; C = ' num2str(C_OUT(4), '%1.2g')];
                    
            text(82.5, 3.75,  FITstr1, 'fontsize', 14);
            text(82.5, 4.00,  FITstr2, 'fontsize', 14);
            text(82.5, 4.375, FITstr3, 'fontsize', 14);
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PRINT TO PNG: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           

    %SETS CUSTOM PAGE SIZE TO OUTPUT:
        fig1.PaperPositionMode = 'auto';	
    %PRINT: 
        print(fig1, '-r225', '-dpng', 'MOR_CompositeFit');

       
        
%END OF CnJ 1994 COMPOSITE NLINFIT EXERCISE


