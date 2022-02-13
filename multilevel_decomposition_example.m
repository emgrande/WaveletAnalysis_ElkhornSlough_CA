clear all
close all

%update the path to the file
filename = 'data.csv';

opts= detectImportOptions(filename);
table = readtable(filename,opts);

t=datenum(table.TIMESTAMP); %time
mV = table.mV30;%Eh for the 30cm depth probe at the lower marsh

%Do the wavelet decomposition
[c,l] = wavedec(mV,5,'db5');

%%Now reconstruct the approximation back to the full length
%Reconstruct level 5 approximation from C
A5 = wrcoef('a',c,l,'db5',5);

%Reconstruct the 5 details
D1 = wrcoef('d',c,l,'db5',1);
D2 = wrcoef('d',c,l,'db5',2);
D3 = wrcoef('d',c,l,'db5',3);
D4 = wrcoef('d',c,l,'db5',4);
D5 = wrcoef('d',c,l,'db5',5);

%%% A1
[c,l] = wavedec(mV,1,'db5');
A1 = wrcoef('a',c,l,'db5',1);
% A2
[c,l] = wavedec(mV,2,'db5');
A2 = wrcoef('a',c,l,'db5',2);
% A3
[c,l] = wavedec(mV,3,'db5');
A3 = wrcoef('a',c,l,'db5',3);
%A4
[c,l] = wavedec(mV,4,'db5');
A4 = wrcoef('a',c,l,'db5',4);


