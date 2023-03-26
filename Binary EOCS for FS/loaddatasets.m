
clc; clear all;

% 1.Breast-cancer Dataset
breast_cancer = load('data\breast-cancer.mat');
fprintf('breast-cancer.mat Loaded Successfully \n');


 % 2.Breast Dataset
breast = load('data\breast.mat');
fprintf('breast.mat Loaded Successfully \n');

 % 3.congress Dataset
 congress=load('data\congress.mat'); % KNN impute handles missing data in the votes dataset
 fprintf('congress.mat Loaded Successfully \n');

 % 4.Exactly Dataset
 exactly =load('data\exactly.mat');
 fprintf('exactly.mat Loaded Successfully \n');

 % 5.Exactly2 Dataset
 exactly2 =load('data\exactly2.mat');
 fprintf('exactly2.mat Loaded Successfully \n');

 % 6.Heart Disease dataset
 heart=load('data\heart.mat');
 fprintf('heart.mat Loaded Successfully \n');

 % 7.Ionosphere Dataset
 ionosphere=load('data\ionosphere.mat');
 fprintf('ionosphere.mat Loaded Successfully \n'); 

 % 8.krvskp Dataset
 krvskp=load('data\krvskp.mat');
 fprintf('krvskp.mat Loaded Successfully \n');

 % 9.lymphography Dataset
 lymph=load('data\lymphography.mat');
 fprintf('lymphography.data Loaded Successfully \n');

 % 10.M-of-n Dataset
 mofn =load('data\m-of-n.mat');
 fprintf('m-of-n.mat Loaded Successfully \n');

 % 11.Penglung Dataset
 penglung =load('data\penglung.mat');
 fprintf('penglung.mat Loaded Successfully \n');

 % 12.Sonar Dataset
 sonar=load('data\sonar.mat');
 fprintf('sonar.mat Loaded Successfully \n');

 % 13.SPECT dataset
 spect=load('data\spect.mat');
 fprintf('spect.mat Loaded Successfully \n');

  % 14.tictactoe Dataset
 tictactoe =load('data\tic-tac-toe.mat');
 fprintf('tic-tac-toe.csv Loaded Successfully \n');

  % 15.Vote Dataset
 vote =load('data\vote.mat');
 fprintf('vote.mat Loaded Successfully \n');

  % 16.waveform Dataset
 waveform =load('data\waveform.mat');
 fprintf('waveform.mat Loaded Successfully \n');

  % 17.Wine Dataset
 wine=load('data\wine.mat');
 fprintf('wine.mat Loaded Successfully \n');

  % 18. Zoo Dataset
 zoo=load('data\zoomat.mat');
 fprintf('zoomat.mat Loaded Successfully \n');



