
function [LABELS_ALL, FEATURES_ALL]=const_segmentation(excerpt, bin_scor, channel, settings)
%settings
fs=settings.Sampling_Frequency; %samples per second
window_length=settings.Window_Length; %s
step = settings.Window_Step; %samples
win = window_length*fs;
error_label = 0.75;

%choose data
data=excerpt(channel,:);
bin_scoring=bin_scor(channel,:);
% FEATURES_ALL - matrix MxN, where M is a number of segments, and N
%is a number of features
FEATURES_ALL = [];

% LABELS_ALL - 1xN where N is number of segments
LABELS_ALL = [];

starts = 1:step:length(data);
%segmentation

for s = starts
    if(s+win > size(data,2))
        break;
    else
        x = s:(s+win);
    end
    segment = data(x);
    features = feature_extraction(segment);
    label = 0;
    a=sum(bin_scoring(x))/length(x);
    if a  > error_label
        label = 1;
    end
    LABELS_ALL = [LABELS_ALL, label];
    FEATURES_ALL = [FEATURES_ALL; features];
    
end

end