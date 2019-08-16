%% Import the data, sheet1
[~, ~, raw] = xlsread('C:\Users\Training27\Downloads\mlstFilesR2017b\Book1.xlsx','Sheet1');
raw = raw(2:end,:);
stringVectors = string(raw(:,1));
stringVectors(ismissing(stringVectors)) = '';
raw = raw(:,[2,3,4,5,6,7]);

%% Create output variable
data = reshape([raw{:}],size(raw));

%% Create table
megahitMetrics = table;

%% Allocate imported array to column variable names
megahitMetrics.metric = stringVectors(:,1);
megahitMetrics.SRR1976948 = data(:,1);
megahitMetrics.SRR1977249 = data(:,2);
megahitMetrics.SRR1977296 = data(:,3);
megahitMetrics.SRR1977304 = data(:,4);
megahitMetrics.SRR1977357 = data(:,5);
megahitMetrics.SRR1977365 = data(:,6);


%% Clear temporary variables
clearvars data raw stringVectors;

%% Import the data, sheet2
[~, ~, raw] = xlsread('C:\Users\Training27\Downloads\mlstFilesR2017b\Book1.xlsx','Sheet2');
raw = raw(2:end,:);
stringVectors = string(raw(:,1));
stringVectors(ismissing(stringVectors)) = '';
raw = raw(:,[2,3,4,5,6,7]);

%% Create output variable
data = reshape([raw{:}],size(raw));

%% Create table
idbaMetrics = table;

%% Allocate imported array to column variable names
idbaMetrics.metric = stringVectors(:,1);
idbaMetrics.SRR1976948 = data(:,1);
idbaMetrics.SRR1977249 = data(:,2);
idbaMetrics.SRR1977296 = data(:,3);
idbaMetrics.SRR1977304 = data(:,4);
idbaMetrics.SRR1977357 = data(:,5);
idbaMetrics.SRR1977365 = data(:,6);

%% Clear temporary variables
clearvars data raw stringVectors;

sampleNames = ["SRR1976948" "SRR1977249" "SRR1977296" "SRR1977304" "SRR1977357" "SRR1977365"]
x = categorical({'SRR1976948','SRR1977249','SRR1977296', 'SRR1977304', 'SRR1977357', 'SRR1977365'});

%% contig matrix
%% column 1 is idba & column 2 is megahit
allContigs = [idbaMetrics{1,2:end}; megahitMetrics{1,2:end}]'
%subplot(1,5,1)
barh(x, allContigs)
title('# of contigs')
legend(["idba", "megahit"])


%% total matrix
allTotals = [idbaMetrics{2,2:end}; megahitMetrics{2,2:end}]'
ax = barh(allTotals)
title('total bases')

%% max matrix
allMax = [idbaMetrics{3,2:end}; megahitMetrics{3,2:end}]'
barh(x, allMax)
title('longest contig')

%% avg matrix
allAvg = [idbaMetrics{4,2:end}; megahitMetrics{4,2:end}]'
barh(x, allAvg)
title('average contig length')


%% n50 matrix
allN50 = [idbaMetrics{5,2:end}; megahitMetrics{5,2:end}]'
barh(x, allN50)
title('# of N50 contigs')