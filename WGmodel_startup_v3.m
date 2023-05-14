%% ========== WIND GENERATOR MODEL ========== 
clear all; clc;

% UPDATE: this model does not deal with beta

% WGmodel = 'SFR_WG.slx';

%% Setting up parameters

tsimulation = 50;
X0 = [0.5161 0.5161 1.1861];
xInitial = X0;

% if we set vw = 10
% pinitwindgen = 0.5161;
% wr0          = 1.1861;

% startup wind speed
vw = 10;
[~,~,~,~,pinitwindgen,wr0] = fun_getwindpowercurve_v4(0,vw);
pinitwindgen = pinitwindgen(1);
wr0 = wr0(1);

Tc1 = 0.05;
Tc2 = 0.05;
Hw  = 5;    % inertia
R   = 0.05; % droop

%% Setting up the mechanical power LUT
% Pw - wr LUT

v_vw    = 5:.5:12;

len_v_wr = 401;

% tableData(:,:,i)   = zeros(length(v_vw), len_v_wr);
[m_pw,v_wr,~,~] = fun_getwindpowercurve(0,v_vw); % get 2D table m_pw for given beta
% tableData(:,:)   = m_pw;          % fill the LUT table


%% Setting up the tracking LUT

[~,~,v_pwmpp,v_wrmpp,v_pwdel,v_wrdel] = fun_getwindpowercurve_v4(0,v_vw);

% simOut = sim("SFR_WG");
% simOut3 = sim("WGmodel_v3");
% tableDataRaw = tableDataRaw(:, 2:end);  % get that first NaN column out

% tableDataReshaped   = reshape(tableDataRaw,[length(v_wr) length(v_vw) length(v_beta)]); % reshaped data into cube thingy
% tableData = reshape(repmat([4 5 6 7;16 19 20 23;10 18 23 26],1,2),[4,3,2]);


