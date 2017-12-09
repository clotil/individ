
function [LABELS_ALL, FEATURES_ALL]=const_segmentation(excerpt, bin_scor, channel)
%settings
fs=200;
window_length=0.5;
step = 0.5*fs;
windows = window_length*fs;
error_label = 0.75;

%choose data
data=excerpt(channel,:);
bin_scoring=bin_scor(channel,:);
% FEATURES_ALL - matrix MxN, where M is a number of segments, and N
%is a number of features
FEATURES_ALL = []; 

% LABELS_ALL - 1xN where N is number of segments
LABELS_ALL = [];

%starts = 1:step:length(data);
%segmentation
starts=16300:step:18300;
for s = starts
    if(s+windows > size(data,2))
       break;
    else
    x = s:(s+windows);
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