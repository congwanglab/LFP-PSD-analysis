%以下为使用自定义函数myfilter_cw滤波并保存为.pdf的代码
%运行前请载入ID_stroke_1000.mat数据并将已有的filterspes移入目标目录，否则将重新设计滤波器
last60s=sig(1,(end-60000+1):end);
first60s=sig(1,1:60000);%提取前后60s的数据
Fs=1000;
figure(1)
subplot(611);plot(first60s,'color','k');hold on;plot(last60s,'color','r');xlabel('Time(s)');ylabel('Amplitude(a.u.)');title('raw stoke data');hold off;
band_alpha=[1 4];band_theta=[4 10];band_beta=[10 30];band_slowgamma=[30 55];band_fastgamma=[55 100];

%调用自定义的myfilter_cw函数按照alpha、theta、beta、slowgamma、fastgamma五个频段进行快速滤波
[alpha1,alpha_newfs1,alpha_N1]=myfilter_cw(first60s,band_alpha(1)-0.5,band_alpha(1),band_alpha(2),band_alpha(2)+0.5,80,1,80,Fs);
[alpha2,alpha_newfs2,alpha_N2]=myfilter_cw(last60s,band_alpha(1)-0.5,band_alpha(1),band_alpha(2),band_alpha(2)+0.5,80,1,80,Fs);
subplot(612);plot(alpha1,'color','k');hold on;plot(alpha2,'color','y');xlabel('Time(s)');ylabel('Amplitude(a.u.)');title('alpha stroke data');hold off;

[theta1,theta_newfs1,theta_N1]=myfilter_cw(first60s,band_theta(1)-0.5,band_theta(1),band_theta(2),band_theta(2)+0.5,80,1,80,Fs);
[theta2,theta_newfs2,theta_N2]=myfilter_cw(last60s,band_theta(1)-0.5,band_theta(1),band_theta(2),band_theta(2)+0.5,80,1,80,Fs);
subplot(613);plot(theta1,'color','k');hold on;plot(theta2,'color',[1,0,1]);xlabel('Time(s)');ylabel('Amplitude(a.u.)');title('theta stoke data');hold off;

[beta1,beta_newfs1,beta_N1]=myfilter_cw(first60s,band_beta(1)-0.5,band_beta(1),band_beta(2),band_beta(2)+0.5,80,1,80,Fs);
[beta2,beta_newfs2,beta_N2]=myfilter_cw(last60s,band_beta(1)-0.5,band_beta(1),band_beta(2),band_beta(2)+0.5,80,1,80,Fs);
subplot(614);plot(beta1,'color','k');hold on;plot(beta2,'color',[0.5,1,0]);xlabel('Time(s)');ylabel('Amplitude(a.u.)');title('beta stoke data');hold off;

[slowgamma1,slowgamma_newfs1,N1]=myfilter_cw(first60s,band_slowgamma(1)-0.5,band_slowgamma(1),band_slowgamma(2),band_slowgamma(2)+0.5,80,1,80,Fs);
[slowgamma2,slowgamma_newfs2,N2]=myfilter_cw(last60s,band_slowgamma(1)-0.5,band_slowgamma(1),band_slowgamma(2),band_slowgamma(2)+0.5,80,1,80,Fs);
subplot(615);plot(slowgamma1,'color','k');hold on;plot(slowgamma2,'color',[0.5,0.5,1]);xlabel('Time(s)');ylabel('Amplitude(a.u.)');title('slowgamma stoke data');hold off;

[fastgamma1,fastgamma_newfs1,fastgamma_N1]=myfilter_cw(first60s,band_fastgamma(1)-0.5,band_fastgamma(1),band_fastgamma(2),band_fastgamma(2)+0.5,80,1,80,Fs);
[fastgamma2,fastgamma_newfs2,fastgamma_N2]=myfilter_cw(last60s,band_fastgamma(1)-0.5,band_fastgamma(1),band_fastgamma(2),band_fastgamma(2)+0.5,80,1,80,Fs);
subplot(616);plot(fastgamma1,'color','k');hold on;plot(fastgamma2,'color',[0.5,0.5,0.5]);xlabel('Time(s)');ylabel('Amplitude(a.u.)');title('fastgamma stoke data');hold off;
set(gcf,'color','w')
set(gcf,'position',[100,100,1000,600])
set(gcf, 'PaperSize', [35,35])
%saveas(figure(1),'IY1 M1 stroke60s.pdf');

%以下为功率谱密度计算代码
%本代码仅展示慢gamma频段LFP滤波结果
%pwelch函数格式：[pxx,f] = pwelch(x,window,noverlap,f,fs)
N=60000;fs=1000;%数据长度和采样频率
window=round(3000);%pwelch窗函数定义
overlap=0.9*window;%overlap是每个窗口之间重叠的长度，通常取33%~50%
figure(2)
[pxx0,fxx0]=pwelch(slowgamma1,window,overlap,[],fs);
plot(fxx0,10*log10(pxx0),'color','k','linewidth',1);hold on
[pxx1,fxx1]=pwelch(slowgamma2,window,overlap,[],fs);
pxx0=10*log10(pxx0);pxx1=10*log10(pxx1);%纵坐标取10*lgx
pxx0=pxx0';pxx1=pxx1';fxx0=fxx0';fxx1=fxx1';
% save IY1_M1_strokefirst60s_PSD pxx0
% save IY1_M1_strokelast60s_PSD pxx1
plot(fxx1,pxx1,'color','r','linewidth',1);hold off
ylabel('PSD(a.u.)');xlabel('Frequency(Hz)');xlim([30,55]);title('IY1 M1 strokelast60s PSD')
legend('stroke first 60s','stroke last 60s')
set(gcf,'color','w')
set(gcf,'position',[100,100,800,400])
set(gcf, 'PaperSize', [25,25])
% saveas(figure(2),'IY1 M1 stroke.pdf');
% saveas(figure(2),'IY1 M1 stroke.fig');
sum_lowlim_a=floor(30/500*length(fxx0));
sum_uplim_a=ceil(55/500*length(fxx0));
sum_lowlim_b=floor(30/500*length(fxx1));
sum_uplim_b=ceil(55/500*length(fxx1));
a=sum(pxx0(:,sum_lowlim_a:sum_uplim_a));%卒中前X轴为30-55的所有y值求和
b=sum(pxx1(:,sum_lowlim_b:sum_uplim_b));%卒中后X轴为30-55的所有y值求和

%以下为PSD heatmap绘制代码
params.Fs=1000;params.tapers=[3 5];params.fpass=[1 100];movingwin=[2 0.1];
[S1,t1,f1]=mtspecgramc(first60s,movingwin,params);
figure(3)
subplot(211)
plot_matrix(S1,t1,f1);title('IY1 M1 strokefirst60s PSD');
colormap jet;
xlabel('Time(s)');ylabel('Frequency(Hz)');
axis([0,60,0,100]);
[S2,t2,f2]=mtspecgramc(last60s,movingwin,params);
subplot(212)
plot_matrix(S2,t2,f2);title('IY1 M1 strokelast60s PSD');
colormap jet;
xlabel('Time(s)');ylabel('Frequency(Hz)');
axis([0,60,0,100]);
% saveas(figure(3),'IY1 M1 stroke heatmap.fig');