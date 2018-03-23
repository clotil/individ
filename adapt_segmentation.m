function [LABELS_ALL, FEATURES_ALL] =adapt_segmentation(excerpt, bin_scor, settings)
%[LABELS_ALL, FEATURES_ALL]    
    fs=settings.Sampling_Frequency; %samples per second
    window_length=settings.Window_Length; %s
    step = settings.Window_Step; %samples
    win = window_length*fs; %samples
    error_label = 0.75;
    %s=struct('Window_Length', 2, 'Window_Step', 20, 'Sampling_Frequency', 200)
    
    data=[];
    scorings=[];
    num_channels=[2 3 5 15 16];
    % FEATURES_ALL - matrix MxN, where M is a number of segments, and N
    %is a number of features
    FEATURES_ALL = []; 
    
    % LABELS_ALL - 1xN where N is number of segments
    LABELS_ALL = [];
    %set multi channel 3EEG+2EOG channels
    for i=1:23
        if(ismember(i, num_channels))
            data=[data; excerpt(i,:)];
            scorings=[scorings; bin_scor(i,:)];
        else 
            continue;
        end
    
    end
    scors=any(scorings);
    adapt_borders=set_adapt_borders(data,scors,settings);
    starts=[1 adapt_borders size(data,2)];
   
    
    for s = starts
    if(s+win > size(data,2))
       break;
    else
    x = s:(s+win);
    end
    %multi_channel mode:
    segment = data(:, x);
    features = feature_extraction_multi_channel(segment);
    %single channel mode:
    %segment=data(2,x);
    %features=feature_extraction(segment);
    %scors=scorings(2,:);
    %------
    
    label = 0;
    a=sum(scors(x))/length(x);
    if a  > error_label
       label = 1;
   end
   LABELS_ALL = [LABELS_ALL, label];
   FEATURES_ALL = [FEATURES_ALL; features];
   
    end
end