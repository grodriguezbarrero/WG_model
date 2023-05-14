function [m_pw,v_wr,v_pwmpp,v_wrmpp,v_pwdel,v_wrdel] = fun_getwindpowercurve_v3(v_beta,v_vw)

% This function computes the power-speed curves for wind generation.
% The power-speed curve of a 1.5 MW wind generator is used for this
% purpose. The resulting curve must be appropriately scaled.
%
% Input:    angle of attack, beta, and wind speed, vw
% Output:   wind power, pw, rotor speed, wr, MPP power, pwmpp, MPP rotor
%           speed, wrmpp

deload = 0.1; % percentage of deloading
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
v_pwdel = (1-deload) * v_pwmpp; % deloaded

% ==> Algorithm to obtain deloaded speed and power:
% Look up for the "0.9*max(m_pw,[],2)" value (in other words, pw_del) and
% see its corresponding i. Then we look for the corresponding wr value with
% that i.

% look for the value closest to pw_del on the right hand side of pmax and
% take note of the index. Then obtain the associated wr
for iw = nvw:-1:1
    % it takes the right half of the curve after the corresponding MPP point
    % and gets it index of the deloaded power
    [~,v_iwrdel(iw)] = min(abs(m_pw(iw,v_iwrmpp(iw):end) - v_pwdel(iw)));
    v_Wrdel(iw)      = v_Wr(v_iwrmpp(iw)+v_iwrdel(iw)); % gives the corresponding wr
end


ipwmppn = find(v_pwmpp<=1,1,'last'); % nominal power (1 pu)
Wrn = v_Wr(v_iwrmpp(ipwmppn)); % nominal speed
v_wr = v_Wr/Wrn;
%v_wr = v_Wr;

v_Wrmpp = v_Wr(v_iwrmpp);
v_wrmpp = v_Wrmpp/Wrn; % speed corresponding to MPP
v_wrdel = v_Wrdel/Wrn; % speed corresponding to deloaded operation points

figure(1)
plot(v_wr,m_pw',':b');hold on;
plot(v_wrmpp,v_pwmpp,'-r');hold on;
plot(v_wrdel,v_pwdel,'-r');hold off;