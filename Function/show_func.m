f = getSoftplus;
hold off;
plot(-4:0.1:4,zeros(size(-4:0.1:4)),'black--');hold on;
plot(zeros(size(-1:0.1:2)),-1:0.1:2,'black--');hold on;
plot(-4:0.001:4,f.f(-4:0.001:4),'m','linewidth',2);hold on;
plot(-4:0.001:4,f.d(-4:0.001:4,f.f(-4:0.001:4)),'c','linewidth',2);hold on;
%grid on;