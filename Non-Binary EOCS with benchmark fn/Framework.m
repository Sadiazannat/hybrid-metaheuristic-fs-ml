%
%
%

function func = Framework(mode)
    if(strcmp(mode, 'Animating'))
        func = @AnimatingOptimizer;
    elseif(strcmp(mode, 'Performance'))
        func = @Performance;
    else
        error("List of mode: 'AnimatingOptimizer', 'MutiBenchmarks', 'MutiOptimizers'")
    end
end

function bmFuncName = GetBM(name)
    fFunc = ["F1" "F2" "F3" "F4" "F5" "F6" "F7" "F8" "F9" "F10" "F11" "F12" "F13" "F14" "F15" "F16" "F17" "F18" "F19" "F20" "F21" "F22" "F23"];
    bmFuncName = name;
    if size(name, 2) <= 1     
        
        if strcmp(name, 'F')
            bmFuncName = fFunc;
        end
    end
end

function AnimatingOptimizer(bmFuncName, op, algorithms)
    numIteration = op.max_nIter;
    pauseMode = false;
    pauseModeStepNext = false;
    
    bmFuncName = GetBM(bmFuncName);
    % drawing illustration
    zeroFitness = zeros(op.numAgent, 1);
    zeroVariable = zeros(op.numAgent, 2);

    graphHandle.fig1 = figure;
    set(graphHandle.fig1, 'Position', [50, 50, 1000, 1000]);
    set(graphHandle.fig1, 'DoubleBuffer', 'on');    

    graphHandle.subplot1 = subplot(2, 2, 2);
    hold on;
    bestPlotHandle = plot(1:numIteration, zeros(1, numIteration));
    xlabel('Iteration');
    hold off;
    drawnow;

    graphHandle.subplot2 = subplot(2, 2, 1);
    ax = gca;
    axtoolbar(ax, {'rotate'});
   
    hold on;
    [xValues, yValues] = meshgrid(0:0.5:1, 0:0.5:1);
    zValues = zeros(3, 3);
    lastSurface = surfl(xValues, yValues, zValues);
    populationPlotHandle = plot3(zeroVariable(:,1), zeroVariable(:,2), zeroFitness(:), 'yp');
    bestFitnessPopPlotHandle = plot3(0., 0., 100., 'rs');
    hold off;
    view ([-7 -9 10]);
    drawnow;

    graphHandle.subplot3 = subplot(2, 2, 3);
    ax = gca;
    ax.Position = [0.0 0.0 0.5 0.45];
    tb = axtoolbar(ax, {});
    % button pause
    btn = axtoolbarbtn(tb,'state');
    btn.Icon = 'btnPause.png';
    btn.Tooltip = 'Pause';
    btn.ValueChangedFcn = @pauseCallback;
    function pauseCallback(src,event)
        switch src.Value
            case 'off'
                pauseMode = false;
                graphHandle.consoleTxt.String(1) = {'\color{gray}[Simulating]'};
            case 'on'
                pauseMode = true;
                graphHandle.consoleTxt.String(1) = {'\color{gray}[Paused Mode]'};
        end
    end
    % button continue
    btn = axtoolbarbtn(tb,'push');
    btn.Icon = 'btnPlay.png';
    btn.Tooltip = 'Next Algorithm';
    btn.ButtonPushedFcn = @playCallback;
    function playCallback(src,event)
        pauseModeStepNext = true;
    end    

    % console area
    xlim([0 5])
    ylim([0 5])
    txtstr(1)={'\color{gray}[Simulating]'};
    txtstr(2)={'\color{black}Interation: 0'};
    txtstr(3)={'\color{black}... '};
    txtstr(4)={'\color{black}... '};
    graphHandle.consoleTxt = text(0.2, 4.5, txtstr,'horizontal','left', 'FontSize', 14);
    % table overlay
    graphHandle.bmData(1, :) = [{''}; {''}; {0}; {false}];
    tblHandle = uitable(graphHandle.fig1,...
        'Data', graphHandle.bmData,...
        'ColumnName', {'Fn', 'Fitness', 'Iter', 'Compare'},...
        'ColumnWidth', {150, 200, 50, 65}, ...
        'ColumnEditable', [false false false true],...
        'CellEditCallback', @cellEditCallback);

    function cellEditCallback(Indices, DisplayIndices, PreviousData, EditData, NewData, Error, Source, EventName)
        algoIdx = size(graphHandle.bmData, 1);
        if DisplayIndices.Indices(1) == algoIdx
            return
        end
        % toggle fitness line comparision
        lval = graphHandle.bmData(DisplayIndices.Indices(1), DisplayIndices.Indices(2));
        graphHandle.bmData(DisplayIndices.Indices(1), DisplayIndices.Indices(2)) = {~lval{1}};
        
        % update fitness comparison plot
        maxIter = length(plotFitnessComparison{1});
        numPlot = 0;
        for i2=2:size(plotFitnessComparison, 2)
            c = graphHandle.bmData(i2, :);
            if c{4} == false
                continue
            end
            numPlot = numPlot + 1;
            j3 = length(plotFitnessComparison{i2});
            if j3 > maxIter
                maxIter = j3;
            end
        end
        % draw plot
        if numPlot > 0
            subplot(graphHandle.subplot4);
            cla reset;
            drawnow
            hold on
            legendTxt = [""];
            tmp = plotFitnessComparison';
            for j3=1:size(plotFitnessComparison, 2)
                c = graphHandle.bmData(j3, :);
                if c{4} == false
                    continue
                end
                data = tmp{j3};
                lval = data(end);
                len = length(data);
                for i3=len:maxIter
                    data(i3) = lval;
                end
                legendTxt(j3) = string(c{1});
                plot(1:maxIter, data);
            end
            legend(legendTxt);
            hold off
            drawnow
        end
    end
    set(tblHandle,'units','normalized');
    set(tblHandle,'position', [0  0 0.5 0.35]);

    graphHandle.subplot4 = subplot(2, 2, 4);    
    xlabel('Iteration');
    ylabel('Fitness');
    ax = gca;
    ax.Position = [0.55 0.05 0.43 0.4];
    hold on
    plotFitnessComparison = {};
    hold off
    drawnow

    bestVariables = zeros(1, op.numAgent);
    bestFitness = 0.;
    algorithmBestFn = 0.;
    itrCount = 0;

    function cont = onIterating(itr, fitnessArray, variableArray)
        itrCount = itr;
        %
        [maximumFitness, bestIdx] = min(fitnessArray);
        xBest = variableArray(bestIdx,:);
        % save value
        bestFitness = maximumFitness;
        bestVariables = xBest;
        % fitness line
        plotvector = get(bestPlotHandle,'YData');
        plotvector(itr:numIteration)= abs(maximumFitness - algorithmBestFn);
        set(bestPlotHandle, 'YData', plotvector);
        %
        algoIdx = size(graphHandle.bmData, 1);
        if(size(plotFitnessComparison, 2) < algoIdx)
            plotFitnessComparison{algoIdx} = [];
        end
        plotFitnessComparison{algoIdx}(end + 1) = maximumFitness;

        % text
        graphHandle.consoleTxt.String(2) = {sprintf('\\color{black}Iteration %d, Fitness %s', itr, num2str(abs(maximumFitness - algorithmBestFn), '%.20f'))};
        graphHandle.consoleTxt.String(3) = {sprintf('\\color{black}Function solutions: [%f %f]', bm.optimal_solution(1), bm.optimal_solution(2))};
        graphHandle.consoleTxt.String(4) = {sprintf('\\color{black}Algorithm solutions: [%s %s]', num2str(xBest(1), '%.16f'), num2str(xBest(2), '%.16f'))};
        % plot variables        
        set(populationPlotHandle, 'XData', variableArray(:,1), 'YData', variableArray(:,2), 'ZData', fitnessArray);
        set(bestFitnessPopPlotHandle, 'XData', xBest(1), 'YData', xBest(2), 'ZData', maximumFitness);
        drawnow;
        %
        cont = true;
        if (itr >= op.max_nIter) || (abs(maximumFitness - algorithmBestFn) <= op.fitness_threshold)
            cont = false;
        end
    end
    % wait a quire for figure displayed completely
    pause(1.6);
    %
    for t=1:op.repeat
        for i=1:length(bmFuncName)
            name = bmFuncName(i);
            bm = BenchmarkFunction(name, 2);        
%             if bm.variable_num ~= 2
%                 fprintf('Error, function %s does not support 2 variables\n', name);
%                 continue;
%             end
            %
            if size(bm.max_search_range, 2) > 1
                if rand() < 0.5
                    upper_bound = bm.max_search_range(1);
                else
                    upper_bound = bm.max_search_range(2);
                end
            else
                upper_bound = bm.max_search_range;
            end
            if size(bm.min_search_range, 2) > 1
                if rand() < 0.5
                    lower_bound = bm.min_search_range(1);
                else
                    lower_bound = bm.min_search_range(2);
                end
            else
                lower_bound = bm.min_search_range;
            end
            %
            for j=2:length(algorithms)
                funcObj = algorithms(j);
                targetAlName = funcObj.name;
                %
                graphHandle.bmData(end, 1) = {convertStringsToChars(strcat(name, '-', targetAlName))};    
                tblHandle.set('Data', graphHandle.bmData);
    
                hold on;
                set(graphHandle.fig1, 'Name', strcat(targetAlName, '-', name));
    
                subplot(graphHandle.subplot1);
                axis([1 numIteration lower_bound upper_bound]);
                ax = gca;
                ax.Position = [0.55 0.55 0.43 0.4];
                bestPlotHandle = plot(1:numIteration, zeros(1, numIteration));
                hold off;
                drawnow;
    
                axis tight;
                grid on;
                box on;
            
                title(sprintf("Benchmark: %s", name));                
                xlabel('Iteration');
                ylabel('Best score obtained so far');                

                subplot(graphHandle.subplot2);            
                xlabel('x1');
                ylabel('x2');
                zlabel('f(x)');
                title(sprintf("Algorithm: %s", targetAlName));
                ax = gca;
                ax.Position = [0.05 0.5 0.45 0.45];
                
                delta = (upper_bound - lower_bound) / 300.;
                limit = fix((upper_bound - lower_bound) / delta) + 1.; % keep limit always is at ~300
                [xValues, yValues] = meshgrid(lower_bound: delta:upper_bound, lower_bound: delta:upper_bound);
                zValues= zeros(limit, limit);
                for j2 = 1: limit
                    for k2 = 1: limit
                        zValues(j2, k2) = bm.fitnessFunc([xValues(j2,k2) yValues(j2,k2)]);
                    end
                end
                delete(lastSurface)
                hold on;
                lastSurface = surfl(xValues, yValues, zValues);
                colormap default;
                shading interp;            
                hold off;
                drawnow;
            
                axis tight
                grid on
                box on

                subplot(graphHandle.subplot4)
                title("Fitness comparison");
                ax = gca;
                ax.Position = [0.55 0.05 0.43 0.4];
    
                algorithmBestFn = bm.fitnessFunc(bm.optimal_solution);
    
                funcObj.bootstrap(op.numAgent, bm.variable_num, upper_bound, lower_bound, bm.fitnessFunc, numIteration, @onIterating);
                
                % update table
                graphHandle.bmData(end, 1) = {convertStringsToChars(strcat(name, '-', targetAlName))};            
                graphHandle.bmData(end, 2) = {convertStringsToChars(num2str(abs(bestFitness - algorithmBestFn), '%.25f'))};
                graphHandle.bmData(end, 3) = {itrCount};
                graphHandle.bmData(end+1, :) = [{''}; {''}; {0}; {false}];
                tblHandle.set('Data', graphHandle.bmData);
        
                %
                fprintf('---------------------- %s - %s\n', targetAlName, name);
                display(['Function best solution: ', num2str(bm.optimal_solution, ' %.16f')]);
                display(['Function best fitness: ', num2str(algorithmBestFn, ' %.16f')]);
                display(['Algorithm best solution: ', num2str(bestVariables, ' %.16f')]);
                display(['Algorithm best fitness: ', num2str(bestFitness, ' %.16f')]);
                
                % pause mode
                if pauseMode
                    while(true)
                        graphHandle.consoleTxt.String(1) = {'\color{gray}[Paused]'};
                        pause(0.8);
                        if pauseModeStepNext
                            pauseModeStepNext = false;
                            if pauseMode
                                graphHandle.consoleTxt.String(1) = {'\color{gray}[Paused Mode]'};
                            else
                                graphHandle.consoleTxt.String(1) = {'\color{gray}[Simulating]'};
                            end    
                            break
                        end
                    end
                end
            end
        end
    end
end

function Performance(times, dim, bmFuncName, numAgent, numIteration, algorithms)
    bmFuncName = GetBM(bmFuncName);

    graphHandle.fig1 = figure("Name", "Performance Testing");
    set(graphHandle.fig1, 'Position', [50, 50, 1100, 1000]);
    set(graphHandle.fig1, 'DoubleBuffer', 'on');

    graphHandle.subplot2 = subplot(2, 2, 1);
    hold on;
    bestPlotHandle = plot(1:times, zeros(1, times));
    animPlotXHandle = xlabel('Iteration');
    hold off;
    drawnow;

    graphHandle.subplot1 = subplot(2, 2, 3);
    graphHandle.bmData2(1, :) = [{''}, {''}];
    tblHandle2 = uitable(graphHandle.fig1,...
        'Data', graphHandle.bmData2,...
        'ColumnName', {'Fitness', 'Dimession'},...
        'ColumnWidth', {200, 100});

    pos = get(graphHandle.subplot1,'position');
    delete(graphHandle.subplot1);
    set(tblHandle2,'units','normalized');
    set(tblHandle2,'position',pos);
   
    graphHandle.subplot3 = subplot(2, 2, [2, 4]);
    graphHandle.bmData(1, :) = [{''}; {''}; {''}];
    tblHandle = uitable(graphHandle.fig1,...
        'Data', graphHandle.bmData,...
        'ColumnName', {'Fn', 'Avg Fitness', 'Dim'},...
        'ColumnWidth', {80, 200, 50});

    pos = get(graphHandle.subplot3,'position');
    delete(graphHandle.subplot3);
    set(tblHandle,'units','normalized');
    set(tblHandle,'position',pos);
    drawnow;
    %
    bestFitness = zeros(times, 1);
    %
    for i=1:length(bmFuncName)
        name = bmFuncName(i);
        bm = BenchmarkFunction(name, dim);
        %
        if size(bm.max_search_range, 2) > 1
            if rand() < 0.5
                upper_bound = bm.max_search_range(1);
            else
                upper_bound = bm.max_search_range(2);
            end
        else
            upper_bound = bm.max_search_range;
        end

        if size(bm.min_search_range, 2) > 1
            if rand() < 0.5
                lower_bound = bm.min_search_range(1);
            else
                lower_bound = bm.min_search_range(2);
            end
        else
            lower_bound = bm.min_search_range;
        end        
        %
        for j=2:length(algorithms)
            funcObj = algorithms(j);
            targetAlName = funcObj.name;

            subplot(graphHandle.subplot2);     
            title(strcat(name, '-', targetAlName));

            %
            graphHandle.bmData(end, 1) = {convertStringsToChars(strcat(name, '-', targetAlName))};    
            tblHandle.set('Data', graphHandle.bmData);
            % reset data of table 1
            a2 = [{''}, {''}];
            graphHandle.bmData2 = a2;
            tblHandle2.set('Data', graphHandle.bmData2);
            drawnow;

            algorithmBestFn = bm.fitnessFunc(bm.optimal_solution);
            bestFitness = zeros(times, 1);
            for k=1:times                    
                onIterating = @(~, fitnessArray, ~) FirstMin(fitnessArray, k);
                funcObj.bootstrap(numAgent, bm.variable_num, upper_bound, lower_bound, bm.fitnessFunc, numIteration, onIterating);
                
                %
                subplot(graphHandle.subplot2);            
                plotvector = get(bestPlotHandle,'YData');
                plotvector(k:times)= bestFitness(k) - algorithmBestFn;
                set(bestPlotHandle, 'YData', plotvector);
                set(animPlotXHandle, 'String', sprintf('Times %d, Avg %4.3f', k, mean(bestFitness(1:k)) - algorithmBestFn));
                drawnow;
                
                % update table        
                graphHandle.bmData2(1, 1) = {convertStringsToChars(num2str(bestFitness(k) - algorithmBestFn, '%.25f'))};
                graphHandle.bmData2(1, 2) = {convertStringsToChars(num2str(bm.variable_num))};
                graphHandle.bmData2 = vertcat([{''}, {''}], graphHandle.bmData2);
                tblHandle2.set('Data', graphHandle.bmData2);
                drawnow;
            end

            % update table
            graphHandle.bmData(end, 1) = {convertStringsToChars(strcat(name, '-', targetAlName))};            
            graphHandle.bmData(end, 2) = {convertStringsToChars(num2str(mean(bestFitness) - algorithmBestFn, '%.25f'))};
            graphHandle.bmData(end, 3) = {convertStringsToChars(num2str(bm.variable_num))};
            graphHandle.bmData(end+1, :) = [{''}; {''}; {''}];
            tblHandle.set('Data', graphHandle.bmData);   
            drawnow;
        end
    end

    function FirstMin(arr,k)
        [a, ~] = min(arr);
        bestFitness(k) = a;
    end
end