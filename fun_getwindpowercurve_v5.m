function [v_pw,v_wr,pwmpp,wrmpp,pwdel,wrdel] = fun_getwindpowercurve_v5(beta,vw)

% This newer version uses scalar values as inputs, rather than vectors.
% The MPP and deloaded outputs are also scalar, not vectors.

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

nwr = length(v_Wr);

v_pw    = zeros(1,nwr);
v_wr    = zeros(1,nwr);
pwmpp = 0;
wrmpp = 0;
pwdel = 0;
wrdel = 0;
iwrmpp= 0;

lambda = v_Wr*Rb./vw;
delta = (1./(lambda+v_cp(8).*beta)-v_cp(9)./(1+beta.^3));
Cp = v_cp(1)*(v_cp(2).*delta-v_cp(3).*beta-v_cp(4).*beta.^v_cp(5)-v_cp(6)).*exp(-v_cp(7).*delta);
v_pw(:) = Cp*rho/2*Aw*vw.^3/Pn; % per unit mechanical power

[pwmpp,iwrmpp] = max(v_pw); % MPP
pwdel = (1-deload) * pwmpp; % deloaded

% ==> Algorithm to obtain deloaded speed and power:
% Look up for the "0.9*max(m_pw,[],2)" value (in other words, pw_del) and
% see its corresponding i. Then we look for the corresponding wr value with
% that i.

iwrdel= 0;
wrdel = 0;
Wrdel = 0;

% look for the value closest to pw_del on the right hand side of pmax and
% take note of the index. Then obtain the associated wr

% it takes the right half of the curve after the corresponding MPP point
% and gets it index of the deloaded power
[~,iwrdel] = min(abs(v_pw(iwrmpp:end) - pwdel));
Wrdel    = v_Wr(iwrmpp+iwrdel); % gives the corresponding wr

% ipwmppn = find(v_pwmpp<=1,1,'last'); % nominal power (1 pu)
%ipwmppn = iwrmpp; % nominal power (1 pu)
Wrn = v_Wr(iwrmpp); % nominal speed
v_wr = v_Wr/Wrn;
%v_wr = v_Wr;

Wrmpp = v_Wr(iwrmpp);
wrmpp = Wrmpp/Wrn; % speed corresponding to MPP
wrdel = Wrdel/Wrn; % speed corresponding to deloaded operation points

figure(1)
plot(v_wr,v_pw',':b');hold on;
plot(wrmpp,pwmpp,'-o');hold on;
plot(wrdel,pwdel,'-o');hold off;