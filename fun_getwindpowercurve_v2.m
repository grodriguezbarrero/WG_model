% function [m_pw,v_wr,v_pwmpp,v_wrmpp,v_pwdel,v_wrdel] = fun_getwindpowercurve_v2(v_beta,v_vw)

v_beta = 0.5;
v_vw = [10 11 12];

% This function computes the power-speed curves for wind generation.
% The power-speed curve of a 1.5 MW wind generator is used for this
% purpose. The resulting curve must be appropriately scaled.
%
% Input:    angle of attack, beta, and wind speed, vw
% Output:   wind power, pw, rotor speed, wr, MPP power, pwmpp, MPP rotor
%           speed, wrmpp


rho = 1.275; % air density

% 1.5 MW wind generator data
Rb = 31.2; % blade radius (m)
Aw = Rb^2*pi; % surface 
Pn = 1.5e6; % nominal power (MW)
v_cp = [0.73, 151, 0.58, 0.002, 2.14, 13.2, 18.4, -0.02, -0.003]; % performance coefficients
v_Wr = 0:0.01:4; % rotor speed range (rad/s)

nvw = length(v_vw);

for iw = nvw:-1:1 % for every wind speed:
    
    vw = v_vw(iw);
    lambda = v_Wr*Rb./vw;
    delta = (1./(lambda+v_cp(8).*v_beta)-v_cp(9)./(1+v_beta.^3));
    Cp = v_cp(1)*(v_cp(2).*delta-v_cp(3).*v_beta-v_cp(4).*v_beta.^v_cp(5)-v_cp(6)).*exp(-v_cp(7).*delta);
    m_pw(iw,:) = Cp*rho/2*Aw*vw.^3/Pn; % per unit mechanical power

end

[v_pwmpp,v_iwrmpp] = max(m_pw,[],2); % MPP
% v_pwmpp = 0.9 .* v_pwmpp;
% [v_pwdel,v_iwrdel] = 0.9 * max(m_pw,[],2); % deloaded
v_pwdel = 0.9 * max(m_pw,[],2); % deloaded

% ==> Algorithm to obtain deloaded speed and power:
% Look up for the "0.9*max(m_pw,[],2)" value (in other words, pw_del) and
% see its corresponding i. Then we look for the corresponding wr value with
% that i.

m_pw_rightside = m_pw(1,v_iwrmpp:end);

% look for the value closest to pw_del on the right hand side of pmax - the values
% are already sorted, so we can use the find() function
i_lower  = find(m_pw_rightside <= v_pwdel,1,'first');
i_higher = find(m_pw_rightside >= v_pwdel,1,'last');   

% higher and lower values of pw_del on the table
lower_than_pwdel  = m_pw_rightside(i_lower);
higher_than_pwdel = m_pw_rightside(i_higher);


ipwmppn = find(v_pwmpp<=1,1,'last'); % nominal power (1 pu)
Wrn = v_Wr(v_iwrmpp(ipwmppn)); % nominal speed
v_wr = v_Wr/Wrn;
%v_wr = v_Wr;

v_Wrmpp = v_Wr(v_iwrmpp);
v_wrmpp = v_Wrmpp/Wrn; % speed corresponding to MPP

% we get an average of the two wr values corresponding to pw_del high and
% pw_del low to get the actual deloaded wr!
v_wrdel = (v_wr(v_iwrmpp+i_lower)+v_wr(v_iwrmpp+i_higher))/2;

% v_Wrdel = v_Wr(v_iwrmpp+i_lower);
% v_wrdel = v_Wrdel/Wrn; % speed corresponding to MPP

figure(1)
plot(v_wr,m_pw',':b');hold on;
plot(v_wrmpp,v_pwmpp,'-r');hold on;
plot(v_wrdel,v_pwdel,'-r');hold off;

% plot(v_wr, m_pw);