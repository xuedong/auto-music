clear;
addpath('src');
addpath('src/third-party/matlab-midi/src');
addpath('src/third-party/gitoolbox_2.0_matlab');
addpath('src/third-party/DataHash');
if ~exist('cache', 'dir')
	mkdir('cache')
end

learn_beg = 0;
%learn_end = 3;
learn_end = 99;
%learn_end = 20;

res = {};

% [datasets] is a cell array of cell array (3 classes) of cell arrays (nb_sequences)
%d = Utils.get_datasets(learn_beg, learn_end, {'product'});
d_dif = Utils.get_datasets(learn_beg, learn_end, {'product'}, 'dif');
%d_sum = Utils.get_datasets(learn_beg, learn_end, {'sum'});
%d_dif_sum = Utils.get_datasets(learn_beg, learn_end, {'sum'}, 'dif');

%d_p = Utils.get_datasets(learn_beg, learn_end, {'pitch'});
%d_d = Utils.get_datasets(learn_beg, learn_end, {'duration'}); 
%d_3 = Utils.get_datasets(learn_beg, learn_end, {'product','pitch','duration'}); 
%d_dif_p = Utils.get_datasets(learn_beg, learn_end, {'pitch'},'dif'); 
%d_dif_d = Utils.get_datasets(learn_beg, learn_end, {'duration'},'dif'); 
%d_dif_3 = Utils.get_datasets(learn_beg, learn_end, {'product','pitch','duration'}, 'dif'); 

%k = (learn_end-learn_beg+1) ; % Leave-one-out
%k = 3;
k = 10;

%cv_data = Learning.pre_cross_validation(d, k);
cv_data_dif = Learning.pre_cross_validation(d_dif, k);
%cv_data_sum = Learning.pre_cross_validation(d_sum, k);
%cv_data_dif_sum = Learning.pre_cross_validation(d_dif_sum, k);

%cv_data_d = Learning.pre_cross_validation(d_d, k);
%cv_data_p = Learning.pre_cross_validation(d_p, k);
%cv_data_3 = Learning.pre_cross_validation(d_3, k);
%cv_data_dif_d = Learning.pre_cross_validation(d_dif_d, k);
%cv_data_dif_p = Learning.pre_cross_validation(d_dif_p, k);
%cv_data_dif_3 = Learning.pre_cross_validation(d_dif_3, k);

%params = Utils.gen_params_lm(2, d, 'simple'); % Bigram LM
%params_trigram = Utils.gen_params_lm(3, d, 'simple'); % Bigram LM

%params2_1 = Utils.gen_params_lm(2, d, 'back-off'); % Bigram LM with back-off

%params_mix_bo1 = Utils.gen_params_lm(2, d_dif, 'back-off', struct('alpha', 1)); % Bigram LM with back-off
%params_mix_bo01 = Utils.gen_params_lm(2, d_dif, 'back-off', struct('alpha', 0.1)); % Bigram LM with back-off
%params_mix_bo08 = Utils.gen_params_lm(2, d_dif, 'back-off', struct('alpha', 0.8)); % Bigram LM with back-off

%params_bo = Utils.gen_params_lm(2, d, 'back-off'); % Bigram LM2
%params_mix = Utils.gen_params_lm(2, d, 'simple'); % Bigram LM2
%params_mix3 = Utils.gen_params_lm(3, d_sum, 'simple'); % Bigram LM2
%params_mix4 = Utils.gen_params_lm(4, d_sum, 'simple'); % Bigram LM2
%params_mix5 = Utils.gen_params_lm(5, d_sum, 'simple'); % Bigram LM2

%params_mix_m1 = Utils.gen_params_lm(2, d_dif, 'simple', struct('m',1));
%params_mix_m10 = Utils.gen_params_lm(2, d_dif, 'simple', struct('m',10));
%params_mix_m01 = Utils.gen_params_lm(2, d_dif, 'simple', struct('m',0.1));
%params_mix_m05 = Utils.gen_params_lm(2, d_dif, 'simple', struct('m',0.5));
%params_mix_m08 = Utils.gen_params_lm(2, d_dif, 'simple', struct('m',0.8));

params_mix_inter_uni = Utils.gen_params_lm(2, d_dif, 'interpolation');
params_mix_inter_nouni = Utils.gen_params_lm(2, d_dif, 'interpolation',struct('lambda0',0.1,'lambda',[0.2,0.7]));

%
%params_mix_dif = Utils.gen_params_lm(2, d_dif, 'simple'); % Bigram LM2
%params_mix_sum = Utils.gen_params_lm(3, d_sum, 'simple'); % Bigram LM2
%params_mix_dif_sum = Utils.gen_params_lm(3, d_dif_sum, 'simple'); % Bigram LM2

params_gt = Utils.gen_params_lm(2, d_dif, 'good-turing'); % Bigram LM2
%params_mix_p = Utils.gen_params_lm(2, d_p, 'simple'); % Bigram LM2
%params_mix_d = Utils.gen_params_lm(2, d_d, 'simple'); % Bigram LM2
%params_mix_3 = Utils.gen_params_lm(2, d_3, 'simple'); % Bigram LM2
%params_mix_sum = Utils.gen_params_lm(2, d_sum, 'simple'); % Bigram LM2
%params_mix_dif_p = Utils.gen_params_lm(2, d_dif_p, 'simple'); % Bigram LM2
%params_mix_dif_d = Utils.gen_params_lm(2, d_dif_d, 'simple'); % Bigram LM2
%params_mix_dif_3 = Utils.gen_params_lm(2, d_dif_3, 'simple'); % Bigram LM2


%params_rpni =  Utils.gen_params_rpni(false);
%params_rpni_mix =  Utils.gen_params_rpni(false,params_mix);
%params_rpni_rej =  Utils.gen_params_rpni(true);


params_edsm =  Utils.gen_params_edsm(false);
%params_edsm_rej =  Utils.gen_params_edsm(true);

%params_ktsi_2 =  Utils.gen_params_ktsi(2,false);
%params_ktsi_2_rej =  Utils.gen_params_ktsi(2,true);

%params_alergia =  Utils.gen_params_alergia(0.01,1);

%[res, time] = Utils.add_model(res, cv_data, 'Bigram', 'lm', params);
%[res, time] = Utils.add_model(res, cv_data, 'Trigram', 'lm', params_trigram);
%[res, time] = Utils.add_model(res, cv_data, 'Bigram+BO(1)', 'lm', params2_1);
%[res, time] = Utils.add_model(res, cv_data, 'Bigram+BO(0.8)', 'lm', params2_08);
%[res, time] = Utils.add_model(res, cv_data, 'Bigram_mix+BO(1)', 'lm_mix', params2_1);
%[res, time] = Utils.add_model(res, cv_data, 'Bigram_mix+BO(0.8)', 'lm_mix', params2_08);
%[res, time] = Utils.add_model(res, cv_data_d, 'Bigram_mix-simple', 'lm_mix', params_mix);
%[res, time] = Utils.add_model(res, cv_data_p, 'Bigram_mix-simple', 'lm_mix', params_mix);


%[res, time] = Utils.add_model(res, cv_data_dif, 'Bigram+BO(1) dif', 'lm_mix', params_mix_bo1);
%Utils.disp_results(res);
%[res, time] = Utils.add_model(res, cv_data_dif, 'Bigram+BO(0.1) dif', 'lm_mix', params_mix_bo01);
%Utils.disp_results(res);
%[res, time] = Utils.add_model(res, cv_data_dif, 'Bigram+BO(0.8) dif', 'lm_mix', params_mix_bo08);
%Utils.disp_results(res);
%
%[res, time] = Utils.add_model(res, cv_data, 'Bi-si (product)', 'lm_mix', params_mix);
%[res, time] = Utils.add_model(res, cv_data_dif, 'Bi GT dif', 'lm_mix', params_gt);
%Utils.disp_results(res);

[res, time] = Utils.add_model(res, cv_data_dif, 'Bi inter-uni dif', 'lm_mix', params_mix_inter_uni);
Utils.disp_results(res);

[res, time] = Utils.add_model(res, cv_data_dif, 'Bi inter-nouni dif', 'lm_mix', params_mix_inter_nouni);
Utils.disp_results(res);


%[res, time] = Utils.add_model(res, cv_data, 'Bi-si (product)', 'lm_mix', params_mix);
%[res, time] = Utils.add_model(res, cv_data_dif, 'Bi-si (product) dif', 'lm_mix', params_mix_dif);
%[res, time] = Utils.add_model(res, cv_data_sum, 'Bi-si (sum)', 'lm_mix', params_mix_sum);
%[res, time] = Utils.add_model(res, cv_data_dif_sum, 'Bi-si (sum) dif', 'lm_mix', params_mix_dif_sum);
%[res, time] = Utils.add_model(res, cv_data_sum, '2-si (product)', 'lm_mix', params_mix);
%[res, time] = Utils.add_model(res, cv_data_sum, '3-si (product)', 'lm_mix', params_mix3);
%[res, time] = Utils.add_model(res, cv_data_sum, '4-si (product)', 'lm_mix', params_mix4);
%[res, time] = Utils.add_model(res, cv_data_sum, '5-si (product)', 'lm_mix', params_mix5);
%[res, time] = Utils.add_model(res, cv_data, '2-si ', 'lm_mix', params_mix);
%[res, time] = Utils.add_model(res, cv_data_dif, '2-si dif', 'lm_mix', params_mix_dif);
%[res, time] = Utils.add_model(res, cv_data_sum, '3-si (sum)', 'lm_mix', params_mix_sum);
%[res, time] = Utils.add_model(res, cv_data_dif_sum, '3-si (sum) dif', 'lm_mix', params_mix_dif_sum);

%[res, time] = Utils.add_model(res, cv_data_dif, 'Bi-si m1 dif', 'lm_mix', params_mix_m1);
%Utils.disp_results(res);
%[res, time] = Utils.add_model(res, cv_data_dif, 'Bi-si m10 dif', 'lm_mix', params_mix_m10);
%Utils.disp_results(res);
%[res, time] = Utils.add_model(res, cv_data_dif, 'Bi-si m0.1 dif', 'lm_mix', params_mix_m01);
%Utils.disp_results(res);
%[res, time] = Utils.add_model(res, cv_data_dif, 'Bi-si m0.5 dif', 'lm_mix', params_mix_m05);
%Utils.disp_results(res);
%[res, time] = Utils.add_model(res, cv_data_dif, 'Bi-si m0.8 dif', 'lm_mix', params_mix_m08);
%Utils.disp_results(res);

%[res, time] = Utils.add_model(res, cv_data_p, 'Bi-si (pitch)', 'lm_mix', params_mix_p);
%[res, time] = Utils.add_model(res, cv_data_d, 'Bi-si (duration)', 'lm_mix', params_mix_d);
%[res, time] = Utils.add_model(res, cv_data_3, 'Bi-si (3)', 'lm_mix', params_mix_3);
%[res, time] = Utils.add_model(res, cv_data_p, 'Bi-si (pitch)', 'lm_mix', params_mix_p);
%[res, time] = Utils.add_model(res, cv_data_d, 'Bi-si (duration)', 'lm_mix', params_mix_d);
%[res, time] = Utils.add_model(res, cv_data_3, 'Bi-si (3)', 'lm_mix', params_mix_3);
%[res, time] = Utils.add_model(res, cv_data_sum, 'Bi-si (sum)', 'lm_mix', params_mix_sum);
%[res, time] = Utils.add_model(res, cv_data_dif_p, 'Bi-si (pitch) dif', 'lm_mix', params_mix_dif_p);
%[res, time] = Utils.add_model(res, cv_data_dif_d, 'Bi-si (duration) dif', 'lm_mix', params_mix_dif_d);
%[res, time] = Utils.add_model(res, cv_data_dif_3, 'Bi-si (3) dif', 'lm_mix', params_mix_dif_3);

%[res, time] = Utils.add_model(res, cv_data, 'Rpni', 'rpni', params_rpni);
%[res, time] = Utils.add_model(res, cv_data, 'Rpni+lm_mix', 'rpni+lm_mix', params_rpni_mix);
%[res, time] = Utils.add_model(res, cv_data, 'Rpni_rej', 'rpni', params_rpni_rej);
%[res, time] = Utils.add_model(res, cv_data_sum, 'Rpni (sum)', 'rpni', params_rpni);

%[res, time] = Utils.add_model(res, cv_data, 'Edsm', 'edsm', params_edsm);
%[res, time] = Utils.add_model(res, cv_data, 'Edsm_rej', 'edsm', params_edsm_rej);

%[res, time] = Utils.add_model(res, cv_data, 'KTSI_2', 'edsm', params_ktsi_2);
%[res, time] = Utils.add_model(res, cv_data, 'KTSI_2_rej', 'edsm', params_ktsi_2_rej);

%[res, time] = Utils.add_model(res, cv_data, 'Alergia', 'alergia', params_alergia);
%[res, time] = Utils.add_model(res, cv_data_dif_sum, 'Alergia (sum) dif', 'alergia', params_alergia);

Utils.disp_results(res);
