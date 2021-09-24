function  [output]= Tapped_Delay_Line(Tap_num,Delay,Fc,spead,T_show)
%% basic parameters
F_c = Fc* 1e6;
Spead= spead * (10/36) ;
gain= 2;
total_delay = Tap_num * Delay ; % n sec
tau_vector = 1:Delay:total_delay ;

%% Calculating max doppler frequency
% f= fc * (C+V)/C

F_doppler = F_c * (3*10^8 + Spead)/(3*10^8) ;

%% sampling with 10 times greater than F_doppler //  we use this in order to outline T axis
F_sample = 10 * F_doppler ;
Ts = 1/ F_sample ;
sample_number=(T_show*10^-9)/Ts;
t_vector = 1:sample_number ;




%% algorithms containing  butterworth  and wgn for each Tap
[b,a]= butter(2,F_doppler/(F_sample/2));
    
for i=1:Tap_num
         W_G_N= wgn(length(t_vector),1,0);
         gi= filter(b,a,abs(W_G_N));
         output(:,i)= gain*gi;
end
% %% appearance
[a1,a2]= meshgrid(tau_vector,t_vector);
figure;
surf(a1,a2,output,'FaceColor','interp','EdgeColor','none');
colormap jet;
title('h(t,\tau)');
xlabel('\tau(ns)');
ylabel('n/Ts');
zlabel('|h|');
% [Spead,tau_vector,F_doppler,sample_number,gi,output]=
end

