clear;close all;clc;
global Algorithms;
Algorithms = struct('name', '', 'bootstrap', @()a);

%% list of algorithms
addpath('./Genetic Algorithm')
addpath('./Grey Wolf Optimization')
addpath('./Salp Swarm Algorithm')
addpath('./Black Widow Optimization')
addpath('./Particle Swarm Optimization/')
addpath('./Sine Cosine Algorithm')
addpath('./Differential Evolution')
addpath('./Grasshopper Optimization Algorithm')
addpath('./Harris hawks optimization Algorithm')
addpath('./Jellyfish Search')
addpath('./Whale Optimization')
addpath('./Dragonfly Algorithm')
addpath('./Moth Flame Optimization')
addpath('./MultiVerse Optimization')
addpath('./Wild Horse Optimizer Algorithm')
addpath('./Social Spider Optimization')
addpath('./Cookoo Search Algorithm')
addpath('./Crow Search Algorithm')
addpath('./Atom Search Optimization Algorithm')
addpath('./Equilibrium Optimizer Algorithm')
addpath('./Henry gas optimization Algorithm')
addpath('./EquilibriumOptimizer2ndTry')
addpath('./Hybrid EqulibriumOptimizer Cuckoo method2')





%run('GeneticAlgorithm.m');
%run('GreyWolfOptimizer.m')
%run('SalpSwarmAlgorithm.m')
%run('BlackWidowOptimization.m')
%run('ParticleSwarmOptimization.m')
%run('SineCosineAlgorithm.m')
%run('DifferentialEvolutionAlgorithm.m')
% run('GrasshopperOptimizationAlgorithm.m')
%run('HarrishawksoptimizationAlgorithm.m')
%run('WhaleOptimization.m')
%run('JellyfishSearch.m')
%run('DragonflyAlgorithm.m')
%run('MothFlameOptimization.m')
% run('MultiVerseOptimization.m')
%run('WildHorseOptimizer.m')
%run('SocialSpiderOptimization.m') %2015
%run('CookooSearchAlgorithm.m') %2009
% run('CrowSearchAlgorithm.m') %2020
% run('HGSO.m')
% run('AtomSearch.m')
% run('EquilibriumOptimizer.m')
% run('EquilibriumOptimizer2.m')
run('HybridEquilibriumOptimizerWithCuckooSearchM2.m')





%% you can add more algorithm here
% addpath(...
% run(...

%%=================================
op = {};
% number of agents or solution
op.numAgent = 30;
% number of iteration
op.max_nIter = 1000;
op.max_fitness_invoke = 30000; 
op.fitness_threshold = 1E-3;
% run repeatly
op.repeat = 10;

% you can fill the benchmark functions using the list below
FFunction = ["F"]; % or FFunction = ["F1" "F2" "F3" "F4"]
%{
"_F_" = ["F1" "F2" "F3" "F4" "F5" "F6" "F7" "F8" "F9" "F10" "F11" "F12" "F13" "F14" "F15" "F16" "F17" "F18" "F19" "F20" "F21" "F22" "F23"];
%}

%% Uncomment to run animation of optimizers
fw = Framework('Animating');
fw(FFunction, op, Algorithms);

% number of times for the algorithm to be looped
% performancetest_loop = 100; % loop times
% performancetest_dim = 30; % dimension
% nAgents = 250;
% nIter = 100;
% 
% %% Uncomment to run performance test
% fw = Framework('Performance');
%fw(performancetest_loop, performancetest_dim, FFunction, nAgents, nIter, Algorithms);