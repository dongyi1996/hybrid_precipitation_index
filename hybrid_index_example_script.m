clearvars
close all

%load Arkansas precipiation anomalies and PDSI time series
data = load('pcp_pdsi_arkansas.csv');
pcp00 = data(:,3);
pdsi = data(:,4);
time = datenum(data(:,1),data(:,2),1);
%load f^-1 spectrum
evapo = load('evapo.csv');

%calculate exponentially weighted index for Arkansas
tau   = 5.051;
alpha = 0.222;
beta  = 0.250;
lagmax = 30;
pcpexp = hybrid_index(pcp00, evapo, tau, lagmax, alpha, beta)';

%calculate lagged correlations
[~,~,p_xy_pcpexp,~] = cross_corr(pcpexp,pcp00,12,nan);
[lag,~,p_xy_pdsi,~] = cross_corr(pdsi,pcp00,12,nan);

%Plot the results
figure('units','normalized','outerposition',[0 0 .6 1])

%this panel is equivalent to the middle panel of Fig. B2 in Chelton and Risien 2020
subplot(211)
plot(lag,p_xy_pcpexp,'r','linewidth',1)
hold on
plot(lag,p_xy_pdsi,'k','linewidth',1)
legend('Exp. Weighted Ave.(t) vs Precip. Anoms. (t+lag)','PDSI(t) vs Precip. Anoms. (t+lag)',...
    'AutoUpdate','off','location','northeast')
plot(lag,zeros(25,1),'k')
plot(zeros(21,1),-1:.1:1,'k')
ylim([-1 1])
yticks(-1:.4:1)
xlim([-12 12])
xticks(-12:2:12)
text(-11,-.2,'f^-^1 spectrum for x_2(t)','color','r')
text(-11,-.32,'\tau = 5.051 months','color','r')
text(-11,-.44,'\alpha = 0.222','color','r')
text(-11,-.56,'\beta = 0.250','color','r')
title('Arkansas Lagged Correlations','fontweight','normal')

%calculate the Arkansas hybrid precipitation index for differrent values of tau
%tau = 3, 10, 20, and 36
lagmax = 100;
alpha = 0;
beta  = 0;
pcpexp3 = hybrid_index(pcp00, evapo, 3, lagmax, alpha, beta)';
pcpexp10 = hybrid_index(pcp00, evapo, 10, lagmax, alpha, beta)';
pcpexp20 = hybrid_index(pcp00, evapo, 20, lagmax, alpha, beta)';
pcpexp36 = hybrid_index(pcp00, evapo, 36, lagmax, alpha, beta)';

subplot(212)
plot(time,pcpexp3,'color','k','linewidth',1)
hold on
plot(time,pcpexp10,'color','b','linewidth',1)
plot(time,pcpexp20,'color','g','linewidth',1)
plot(time,pcpexp36,'color','r','linewidth',1)
legend('\tau = 3','\tau = 10','\tau = 20','\tau = 26','AutoUpdate','off','location','southwest')
plot(time,zeros(length(time),1),'color',[.5 .5 .5],'linewidth',.4)
xlim([datenum(1948,1,1) datenum(2017,6,1)])
datetick('x','keeplimits')
ylim([-4 4])
title('Arkansas PCPexp with \alpha = \beta = 0','fontweight','normal')
set(gcf,'color','w');
export_fig('pcpexp_arkansas_results','-pdf')
