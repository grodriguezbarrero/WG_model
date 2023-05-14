function [pw_mpp,wr_mpp,pw_del,wr_del] = fun_getPowerAndSpeed(beta,vw)

% gives symbolic expressions for most things, except deloaded wr

syms wr % rotor speed range (rad/s)

deload = 0.1; % percentage of deloading
rho = 1.275; % air density

% wr      = 0;
lambda  = 0;
delta   = 0;
Cp      = 0;
pw      = 0;

Wr_mpp  = 0;
wr_mpp  = 0;
Wr_del  = 0;
wr_del  = 0;
Wrn     = 0;
pw_mpp  = 0;
pw_del  = 0;


% 1.5 MW wind generator data
Rb = 31.2; % blade radius (m)
Aw = Rb^2*pi; % surface 
Pn = 1.5e6; % nominal power (MW)
v_cp = [0.73, 151, 0.58, 0.002, 2.14, 13.2, 18.4, -0.02, -0.003]; % performance coefficients

lambda = wr*Rb./vw;
delta = (1./(lambda+v_cp(8).*beta)-v_cp(9)./(1+beta.^3));
Cp = v_cp(1)*(v_cp(2).*delta-v_cp(3).*beta-v_cp(4).*beta.^v_cp(5)-v_cp(6)).*exp(-v_cp(7).*delta);
pw = Cp*rho/2*Aw*vw.^3/Pn; % per unit mechanical power

% solve for the speed that gives maximum power
Wr_mpp = solve(diff(pw, wr) == 0, wr);
% give the corresponding maximum power (substituting wr with wr_max in the
% pw expression)
pw_mpp = double(subs(pw, wr, Wr_mpp));

% we can get pw_del
pw_del = pw_mpp * (1 - deload);
% and so we get the deloaded speed from the original equation
Wr_del = vpasolve(pw == pw_del, wr, [Wr_mpp 10]);

% nominal speed
Wrn = Wr_mpp;

wr_mpp = Wr_mpp/Wrn;
wr_del = Wr_del/Wrn;