% Homework 1
%
% Author: David James
% Date: 20180116

colors = ['k','m','b','g','r','c'];
marker = ["p","o"];
ch_legend = cell(6,1);

ch_ln = log(Ch);
ch_mean = [0];
ch_current = [0];
ra_current = [0];
nu_current = [0];
figure(1);
hold on;

for i = [1:6]
  j = i+8;
  if(i == 1)
    ch_ind = find(Ch == 0);     %% find index of ch values
    ra_current = Ra(ch_ind);    %% collect indexed values from ra
    nu_current = Nu(ch_ind);    %% collect indexed values from nu
    
    % plot current parsed values from Nu and Ra
    loglog(log(ra_current),log(nu_current),"marker",marker(1),"color",colors(1),"MarkerFaceColor",colors(1),"linestyle", 'none');
    hold on
    
    % make a polyfit and plot that over data
    p1 = polyfit(log(ra_current),log(nu_current),1);
    y1 = polyval(p1,log(ra_current));
    loglog(log(ra_current),y1,colors(1),'HandleVisibility','off');
    
    ch_legend{1} = ['Ch = 0e+00; \alpha = ' num2str(p1(1),3)];
    hold on
  else
    ch_ind = find(ch_ln < j & ch_ln > j-1);         %% find index of ch values
    ra_current = Ra(ch_ind);                        %% collect indexed values from ra
    nu_current = Nu(ch_ind);                        %% collect indexed values from nu
    ch_current = Ch(ch_ind);                        %% collect indexed values from ch
    
    ch_mean(i) = mean(ch_current);                  %% calculate mean of ch from parsed values

    % plot current parsed values from Nu and Ra
    loglog(log(ra_current),log(nu_current),"marker",marker(2),"color",colors(i),"MarkerFaceColor",colors(i),"linestyle", 'none');
    hold on
    
    % make a polyfit and plot that over data
    pi = polyfit(log(ra_current),log(nu_current),1);
    yi = polyval(pi,log(ra_current));
    loglog(log(ra_current),yi,colors(i),'HandleVisibility','off');
    
    ch_legend{i} = ['Ch = ' num2str(ch_mean(i),1) '; \alpha = ' num2str(pi(1),3)];
  end
end

% final touches to graph
grid on;
grid minor;
xlabel('Ra (bouyancy force)');
ylabel('Nu (convection strength)');
legend(ch_legend);


