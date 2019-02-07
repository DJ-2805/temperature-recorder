function [out] = sine2line_udf(k, x_in, xbreak)
%SINE2LINE function outputs a sine wave sin(k*x_in) that breaks at x_in =
%xbreak to a line with the value of the sine wave at xbreak.  INPUT ORDER:
%k, x_in, xbreak. 

    %LOGICALS!: 
        lv_sine = (x_in <= xbreak); 
        lv_line = ~lv_sine; 
        
    %OUTPUT COMMAND: 
    out = sin(k*xbreak).*lv_line; 
          sin(k*x_in).*lv_sine + ...
          
        
    plot(x_in, out, '-k', 'linewidth', 1.75);
    grid on


end

