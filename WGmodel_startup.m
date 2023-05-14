%% ========== WIND GENERATOR MODEL ========== 
clear all; clc;

% WGmodel = 'SFR_WG.slx';

%% Setting up parameters

tsimulation = 5;
% X0 = [0 0 0];
xInitial = 0;

% if we set vw = 10
pinitwindgen = 0.5161;
wr_init      = 1.1861;
Pref_init    = 0.5161;

Tc1 = 0.05;
Tc2 = 0.05;
Hw  = 5;    % inertia
R   = 0.05; % droop

%% Setting up the mechanical power LUT
% Pw - wr LUT

v_vw    = 5:1:10;
v_beta  = 0:1:2;

len_v_wr = 401;

for i=1:length(v_beta)
    % tableData(:,:,i)   = zeros(length(v_vw), len_v_wr);
    [m_pw,v_wr,~,~] = fun_getwindpowercurve(v_beta(i),v_vw); % get 2D table m_pw for given beta
    tableData(:,:,i)   = m_pw;          % fill the LUT table
end

%% Setting up the tracking LUT

[~,~,v_pwmpp,v_wrmpp,v_pwdel,v_wrdel] = fun_getwindpowercurve_v4(0,v_vw);

% simOut = sim("SFR_WG");
% simOut3 = sim("WGmodel_v3");
% tableDataRaw = tableDataRaw(:, 2:end);  % get that first NaN column out

% tableDataReshaped   = reshape(tableDataRaw,[length(v_wr) length(v_vw) length(v_beta)]); % reshaped data into cube thingy
% tableData = reshape(repmat([4 5 6 7;16 19 20 23;10 18 23 26],1,2),[4,3,2]);
