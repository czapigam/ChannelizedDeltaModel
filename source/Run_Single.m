% Save items to a new directory
clear; close all;
c.GroupFolder = 'Test';
c.InputFile = 'In_CR'; %Input conditions
c.RunFolder = '001';

dbstop if error;
% dbclear all

%% Do not change below
%Identify folders
c.cdSource = cd; %Input folder (source)
cd .. %move up one 
c.cdModel = cd; %Most upstream file
cd main; %move to main folder
c.cdMain = cd;

%Setup the folder structure for output
c = ArrangeOutput(c);

%Run the model
DeltaModel_Main(c);

