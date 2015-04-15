% dark_array_analysis.m
% close all
clear all
clc


temp = csvread('C:\Users\dhstuart\Dropbox\CLTC\avantesSpectrometer\Cal Files\Dark Array2015_4_15_.csv');
% temp = csvread('C:\Users\dhstuart\Dropbox\CLTC\avantesSpectrometer\Cal Files\Dark Array2015_4_15_ - Copy.csv');
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
end



% figure
% for i = 12:length(intTime)
%     plot(frequency,yResiduals(i,:),'g')
%     hold on
% end
yResidualsAvg = mean(yResiduals(11:end,:));     %only use more stabilized values
% plot(frequency,test,'b')

%% --------regression on linear fits------------
fm = fit(intTime,p(:,1),'power2');
cm = coeffvalues(fm);
M= cm(1)*intTime.^cm(2)+cm(3);

fb = fit(intTime,p(:,2),'power2');
cb = coeffvalues(fb);
B= cb(1)*intTime.^cb(2)+cb(3);

for i=1:length(intTime)
   figure('name',num2str(intTime(i)))
   plot(frequency,scansNorm(i,:))
   hold on
   plot(frequency,M(i).*frequency+B(i)+yResidualsAvg);
   
end

% figure
% plot(frequency,scansNorm(10,:),frequency,out)
% hold on
% out = M(10).*frequency+B(10)+yResiduals(end,:);
% line([frequency(1) frequency(end)],[M(10)*frequency(1)+B(10) M(10)*frequency(end)+B(10)])
% end

mfits = p(:,1);
bfits = p(:,2);