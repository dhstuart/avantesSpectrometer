% dark_array_analysis.m
% close all
clear all
clc


% temp = csvread('C:\Users\dhstuart\Dropbox\CLTC\avantesSpectrometer\Settings\Naked Sphere\Cal Files\Dark Array2015_4_23_.csv');
temp = csvread('C:\Users\dhstuart\Dropbox\CLTC\avantesSpectrometer\Settings\Naked Sphere\Cal Files\Dark Array2015_4_15_.csv');
% temp = csvread('C:\Users\dhstuart\Dropbox\CLTC\avantesSpectrometer\Settings\Naked Sphere\Cal Files\Dark Array2015_4_15_ - Copy.csv');
intTime = temp(2:end,1);
scans = temp(2:end,2:end);

frequency = temp(1,2:end);
figure
for i = 1:length(intTime)
    scansNorm(i,:) = scans(i,:)./intTime(i);
    p(i,:) = polyfit(frequency,scansNorm(i,:),1);
    yResiduals(i,:) = scansNorm(i,:)-polyval(p(i,:),frequency);
    plot(frequency,scansNorm(i,:))
    hold on
    line([360 1000], [polyval(p(i,:),360) polyval(p(i,:),1000)])    %plot fits
%     pause
end



% figure
% for i = 12:length(intTime)
%     plot(frequency,yResiduals(i,:),'g')
%     hold on
% end


%---find the residual jitter around the linear fits. 
%---Only use more stabilized values with longer integration times
yResidualsAvg = mean(yResiduals(11:end,:));     
% plot(frequency,test,'b')

%% --------regression on linear fits------------
%use the coefficients for the linear fits to for a power fit



% fm = fit(intTime,p(:,1),'power2');
% cm = coeffvalues(fm);
% M= cm(1)*intTime.^cm(2)+cm(3);
% 
% fb = fit(intTime,p(:,2),'power2');
% cb = coeffvalues(fb);
% B= cb(1)*intTime.^cb(2)+cb(3);

ft = fittype( 'rat11' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Algorithm = 'Levenberg-Marquardt';
opts.StartPoint = [0.585267750979777 0.223811939491137 0.751267059305653];
fm = fit(intTime, p(:,1), ft, opts);
cm = coeffvalues(fm);
M = (cm(1).*intTime + cm(2))./(intTime+cm(3));

fb = fit(intTime,p(:,2), ft, opts);
cb = coeffvalues(fb);
B = (cb(1).*intTime + cb(2))./(intTime+cb(3));

% for i=1:length(intTime)
%    figure('name',num2str(intTime(i)))
%    plot(frequency,scansNorm(i,:))
%    hold on
%    plot(frequency,M(i).*frequency+B(i)+yResidualsAvg);
%    
% end

% figure
% plot(frequency,scansNorm(10,:),frequency,out)
% hold on
% out = M(10).*frequency+B(10)+yResiduals(end,:);
% line([frequency(1) frequency(end)],[M(10)*frequency(1)+B(10) M(10)*frequency(end)+B(10)])
% end

mfits = p(:,1);
bfits = p(:,2);

figure;plot(intTime,p(:,1),intTime,M)
figure;plot(intTime,p(:,2),intTime,B)