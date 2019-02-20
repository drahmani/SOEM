%% Loading UCR datasets (test and train sets together): UCR_TS_Archive_2015
a=dir('UCR_TS_Archive_2015');
% choose the time series
i=5;
namy =  ['UCR_TS_Archive_2015/' a(i).name '/'];
b=dir(namy);
for j=1:length(b)
    if findstr(b(j).name,'TRAIN')
        X = load( [namy b(j).name]);
        label_trn = X(:,1);
        Xtrn = X(:,2:end);
    end
    if findstr(b(j).name,'TEST')        
        X = load( [namy  b(j).name]);
        label_tst = X(:,1);
        Xtst = X(:,2:end);
    end
end
Xtst = Xtst';
Xtrn = Xtrn';
Y_UCR = [Xtrn Xtst]; % now we have test and train datasets appended
names = cellstr(num2str([label_trn;label_tst]));

