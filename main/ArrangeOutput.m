function c = ArrangeOutput(c)
% Create file structure for output

MainFold = c.cdModel; %Most upstream folder
OutputFold = 'Output';

%% If folders don't exit, make them
if ~exist(fullfile(MainFold,OutputFold)) % Make save folder
    mkdir(fullfile(MainFold,OutputFold)); end

if ~exist(fullfile(MainFold,OutputFold,c.GroupFolder)) % make group folder
    mkdir(fullfile(MainFold,OutputFold,c.GroupFolder)); end

if ~exist(fullfile(MainFold,OutputFold,c.GroupFolder,c.RunFolder)) % make run folder
    mkdir(fullfile(MainFold,OutputFold,c.GroupFolder,c.RunFolder)); end

c.outputFolder = fullfile(MainFold,OutputFold,c.GroupFolder,c.RunFolder);

if ~exist(fullfile(c.outputFolder,'Figs')) % make run folder
    mkdir(fullfile(c.outputFolder,'Figs')); 
else 
    delete(fullfile(c.outputFolder,'Figs','*'));
end

c.FigFolder = fullfile(c.outputFolder,'Figs');
c.DataFolder = fullfile(c.cdSource,'data');

%% Delete contents in Run folder, then remake it
if exist(c.outputFolder) %Delete folder
   warning('Deleting Contents of Folder!'); delete(fullfile(c.outputFolder,'*'));  end  

%% Copy run files to this folder
% copyfile(fullfile(c.CdInput,c.InputFile),fullfile(myfolder,c.InputFile)); %Copy the input files over 
% COPY EVERYTHING JUST IN CASE WE NEED TO Re-RUN!
copyfile(fullfile(c.cdSource,[c.InputFile,'.m']),fullfile(c.outputFolder,[c.InputFile,'.m'])); 
if isfield(c,'ICFile') 
    copyfile(fullfile(c.cdSource,[c.ICFile,'.m']),fullfile(c.outputFolder,[c.ICFile,'.m'])); end



%% Set folder output for the model runs
c.TimeStart = datestr(now,'yyyy_mm_dd_HH_MM_SS');

c.foldername = fullfile(c.cdMain,'Output',c.GroupFolder,c.RunFolder);
c.filenameGif  = fullfile(c.outputFolder,[c.InputFile,'.gif']);
c.filenameMat  = fullfile(c.outputFolder,[c.InputFile,'.mat']);
c.filenameXls  = fullfile(c.outputFolder,[c.InputFile,'.xlsx']);
c.filenameTxt  = fullfile(c.outputFolder,[c.TimeStart,'.txt']);
end