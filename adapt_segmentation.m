function distances=adapt_segmentation(excerpt, bin_scor)
    fs=200; %samples per second
    window_length=0.5; %s
    step = 0.5*fs; %samples
    windows = window_length*fs; %samples
    %error_label = 0.75;
    data=[];
    scors=[];
    num_channels=[2 3 5 15 16];
    window_subnum=ceil(windows/step);
    %set multi channel 3EEG+2EOG channels
    for i=1:23
        if(ismember(i, num_channels))
            data=[data; excerpt(i, :)];
            scors=[scors; bin_scor(i, :)];
        else 
            continue;
        end
    
    end
    starts = 1:step:length(data);
    firsts = 1 : size(starts,2)-window_subnum;
    second= firsts + window_subnum;
    distances=[];
    %segmentation

for i=1:size(firsts,2)
    if(firsts(i)+windows > size(data,2) || second(i)+windows > size(data,2))
       break;
    else
    first_segm_bord=firsts(i):(firsts(i)+windows);
    second_segm_bord=second(i):(second(i)+windows);
    end
    first_segm=data(first_segm_bord);
    second_segm=data(second_segm_bord);
    cov_first=cov(first_segm);
    cov_second=cov(second_segm);
    cur_distance=distance_riemann(cov_first,cov_second);
    distances = [distances cur_distance];
end
       for i=1:size(data,1)
       plot((1:length(data))/200, data(i));
       hold on;
       end
       scatter(second, distances);
       
end