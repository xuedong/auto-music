clear;
addpath('src');
addpath('src/third-party/matlab-midi/src');
addpath('src/third-party/gitoolbox_2.0_matlab');
addpath('src/third-party/DataHash');
addpath('src/third-party/miditoolbox1.1/miditoolbox');
if ~exist('cache', 'dir')
	mkdir('cache')
end

learn_beg = 0;
learn_end = 1;
%learn_end = 99;
%learn_end = 20;
%
%
[h1,d1] = Parser('music/implicita/bach/bach00.imp');
[h2,d2] = Parser('music/implicita/gre/gre00.imp');
[h3,d3] = Parser('music/implicita/scot/scot00.imp');
Utils.write_to_file(h1,d1,'train00_1.mid');
Utils.write_to_file(h2,d2,'train00_2.mid');
Utils.write_to_file(h3,d3,'train00_3.mid');

%d = Utils.get_datasets(learn_beg, learn_end, {'product'});
%d_dif = Utils.get_datasets(learn_beg, learn_end, {'product'}, 'dif');
%d = Utils.get_datasets(learn_beg, learn_end, {'sum'}, 'dif');

k = 2 ;

%cv_data = Learning.pre_cross_validation(d, k);
%cv_data_dif = Learning.pre_cross_validation(d_dif, k);

%params_mix = Utils.gen_params_lm(2, d, 'simple'); % Bigram LM2
%params_mix_dif = Utils.gen_params_lm(2, d, 'back-off'); % Bigram LM2

%params_rpni =  Utils.gen_params_rpni(false);
%params_edsm =  Utils.gen_params_edsm(false);

%params_ktsi_2 =  Utils.gen_params_ktsi(2,false);

%s = Generation.gen_seqs('rpni', params_rpni, cv_data, 10, 60);
%s = Generation.gen_seqs('edsm', params_edsm, cv_data, 1, 40);
%s = Generation.gen_seqs('ktsi', params_ktsi_2, cv_data, 1, 40);
%s = Generation.gen_seqs('lm_mix', params_mix, cv_data, 1, 60);

%for i=1:3
	%for j=1:10
		%Utils.write_to_file(s{i}{j}{1}, s{i}{j}{2}, strcat('gen/rpni_',int2str(i),'_',int2str(j),'.mid'));
	%end
%end
%Utils.play(s{1}{1}{1}, s{1}{1}{2})
%pause
%Utils.play(s{3}{1}{1}, s{3}{1}{2})
%pause
%Utils.play(s{2}{1}{1}, s{2}{1}{2})
