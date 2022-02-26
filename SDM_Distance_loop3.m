clear all;
A=csvread('Matlabdata4.csv',1,0);
[data,text]  = xlsread('Weightdistance.xlsx', 'Sheet1', 'B2:JZ286');%read distance xlsx
rho_results = [];
index = 1;
for thresh = 500:50:500 %from 100 to 4000, step 50
    disp(index);% print loop number
    tmp = data;
    tmp(tmp>thresh) = 0; % set to 0 if the value > thresh
    weight_matrix = 1./ tmp;
    % set infinite value to 0
    weight_matrix_finite = weight_matrix;
    weight_matrix_finite(isinf(weight_matrix_finite)) = 0; 
    T=6;
    N=285; 
    W=normw(weight_matrix_finite);%normw(W1); 
    y=A(:,[3]); 
    x=A(:,[4,5,6,7,8,9]);
    xconstant=ones(N*T,1);
    %生成自变量空间滞后项
    for t=1:T
     t1=(t-1)*N+1;t2=t*N;
     wx(t1:t2,:)=W*x(t1:t2,:);
    end
    [nobs K]=size(x);
    info.lflag=1;
    info.rmax=1
    info.bc=1 
    info.model=3; 
    info.fe=0; 
    results=sar_panel_FE(y,[x wx],W,T,info); 
    vnames=strvcat('logcit','sdgt-1','couplingdiv','gdpdiv','unemploydiv','envdiv','geffidiv','Wsdgt-1','Wcouplingdiv','Wgdpdiv','Wunemploydiv','Wenvdiv','Wgeffidiv');
    prt_sp(results,vnames,1);
    spat_model=1;
    direct_indirect_effects_estimates(results,W,spat_model);
    panel_effects_sdm(results,vnames,W);
    rho_results(index,1) = results.rho;
    L95=results.rho-1.96*(results.rho/results.tstat(13));
    rhoL95_results(index,1)=L95;
    U95=results.rho+1.96*(results.rho/results.tstat(13));
    rhoU95_results(index,1)=U95;
    index = index+1;
end
writematrix(rho_results,'rho_results.txt','Delimiter',',');%save the results