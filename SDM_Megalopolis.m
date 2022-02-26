% 空间面板数据回归（一）
clear
A=csvread('Matlabdata4.csv',1,0);
[row,col] = find(A(:,10)==1); % 筛选出megacity
A = A(row,:);% rows of megacity
W1= xlsread('Weight_matrix_500_Mega.xlsx', 'Sheet1', 'B2:JZ286');%read distance xlsx
T=6; 
N=136; 
W=normw(W1); 
y=A(:,[3]); 
x=A(:,[4,5,6,7,8,9]);
%生成自变量空间滞后项
for t=1:T
    t1=(t-1)*N+1;t2=t*N;
    wx(t1:t2,:)=W*x(t1:t2,:);
end
%设置参数
info.lflag=1; % 0 采用计算速度最快的方法 需设定info.rmin=-1; 1用于大样本数据计算 计算速度较快 需设定info.rmax=1
info.rmax=1
info.bc=1 %0 表示固定效应的空间滞后模型命令计算截面/时间均值的误差； 1 表示采用误差修正方法；通常情况选1
info.model=3; %1 空间固定效应； 2 时间固定效应； 3 空间和时间固定效应
info.fe=0; %不输出固定效应及相应的概率值
%估计模型
results = sar_panel_FE(y,[x wx],W,T,info);
vnames=strvcat('logcit','sdgt-1','couplingdiv','gdpdiv','unemploydiv','envdiv','geffidiv','Wsdgt-1','Wcouplingdiv','Wgdpdiv','Wunemploydiv','Wenvdiv','Wgeffidiv');
prt_sp(results,vnames,1);
spat_model=1; % 0 sar model；1 spatial Durbin model；2 mix between sar and spatial Durbin model 
direct_indirect_effects_estimates(results,W,spat_model);
panel_effects_sdm(results,vnames,W);
