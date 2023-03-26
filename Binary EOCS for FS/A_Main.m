
%---Input-------------------------------------------------------------
% feat   : Feature vector matrix (Instances x Features)
% label  : Label matrix (Instances x 1)
% opts   : Parameter settings 
% opts.N : Number of solutions / population size (* for all methods)
% opts.T : Maximum number of iterations (* for all methods)
% opts.k : Number of k in k-nearest neighbor 

% Some methods have their specific parameters (example: PSO, GA, DE) 
% if you do not set them then they will define as default settings
% * you may open the < m.file > to view or change the parameters
% * you may use 'opts' to set the parameters of method (see example 1)
% * you may also change the < jFitnessFunction.m file >


%---Output------------------------------------------------------------
% FS    : Feature selection model (It contains several results)
% FS.sf : Index of selected features
% FS.ff : Selected features
% FS.nf : Number of selected features
% FS.c  : Convergence curve
% Acc   : Accuracy of validation model



% 15: Hybrid Equilibrium Optimization (HEO) 
clear, clc, close;

%datasets = ["data\breast-cancer.mat" "data\breast.mat" "data\congress.mat" "data\exactly.mat" "data\exactly2.mat" "data\heart.mat" "data\ionosphere.mat" "data\krvskp.mat" "data\lymphography.mat" "data\m-of-n.mat" "data\penglung.mat" "data\sonar.mat" "data\spect.mat" "data\tic-tac-toe.mat" "data\vote.mat" "data\waveform.mat" "data\wine.mat" "data\zoomat.mat"];
%best_ks = [4 2 4 32 12 2 4 4 3 35 5 14 7 4 2 37 4 5];
datasets = ["data\exactly.mat" "data\exactly2.mat"];
best_ks = [5 5];

for file=1:18
proc_times = zeros(1,20);
feat_selected = zeros(1,20);
accuracy = zeros(1,20);
for init = 1:20
% Number of k in K-nearest neighbor
%opts.k = 5; 
opts.k = best_ks(file);
% Ratio of validation data
ho = 0.2;

% Common parameter settings 
opts.N = 30;     % number of solutions
opts.T = 20;    % maximum number of iterations
% Parameter - EO
opts.a1  = 2;      % constant
opts.a2  = 1;      % constant
opts.GP  = 0.5;    % generation probability 
% Load dataset
load(datasets(file)); 
fprintf("\n Run Number %g%", init)
% Divide data into training and validation sets
HO = cvpartition(label,'HoldOut',ho);  
opts.Model = HO; 
% Perform feature selection 
FS     = jfs('heo',feat,label,opts);
% Define index of selected features
proc_times(1,init) = FS.t;
sf_idx = FS.sf;
n = numel(sf_idx); 
% disp("feat selected count",n);
feat_selected(1,init) = n;
fprintf('\n feat selected count = %g%',n);
% Accuracy  
Acc    = jknn(feat(:,sf_idx),label,opts); 
accuracy(1,init) = Acc;
% % Plot convergence
% plot(FS.c); grid on;
% xlabel('Number of Iterations'); 
% ylabel('Fitness Value'); 
% title('EO');
end

fprintf('\n AVG accuracy = %g%',mean(accuracy));
fprintf('\n AVG feat selected count = %g%',mean(feat_selected));
fprintf('\n AVG processing time = %g%',mean(proc_times));
fprintf('\n SD accuracy = %g%',std(accuracy));
fprintf('\n SD feat selected count = %g%',std(feat_selected));
fprintf('\n SD processing time = %g%',std(proc_times));

fprintf('\n These values are for %s\n',datasets(file));

end