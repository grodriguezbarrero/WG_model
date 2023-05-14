%% main_WGmodel

%% Setting up the LUT
% WGmodel = 'SFR_WG.slx';

% pinitwindgen = 1;
% Tc1 = 1;
% Tc2 = 1;

v_vw    = 5:10;

tableData = [];

[m_pw,v_wr,v_pwmpp,v_wrmpp] = fun_getwindpowercurve(0,v_vw); % get 2D table m_pw for given beta

% tableDataRaw = tableDataRaw(:, 2:end);  % get that first NaN column out
