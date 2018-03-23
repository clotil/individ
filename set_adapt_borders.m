function adapt_borders=set_adapt_borders(data, scors, settings)
    fs=settings.Sampling_Frequency; %samples per second
    window_length=settings.Window_Length; %s
    step = settings.Window_Step; %samples
    win = window_length*fs; %samples
    starts = win:step:length(data)-win;
%     for s = starts
%         frt = data(:, max(1, s-win):s );
%         scd = data(:,s:min(length(data), s+win);
%         
%     end
    %firsts = 1 : size(starts,2)-window_subnum;
    %second= firsts + window_subnum;
    %starts_new=[];
    distances=[];
    %segmentation
for s=starts %1:size(firsts,2)
    
   % first_segm_bord=;%firsts(i):(firsts(i)+windows);
    %starts_new=[starts_new starts(i)];
   % second_segm_bord= data(:,s:min(length(data), s+win); %second(i):(second(i)+windows);
    first_segm=data(:, max(1, s-win):s )';% data(:, first_segm_bord)';
    second_segm=data(:,s:min(length(data), s+win))'; %data(:, second_segm_bord)';
    cov_first=cov(first_segm);
    cov_second=cov(second_segm);
    cur_distance=distance_riemann(cov_first,cov_second);
    distances = [distances cur_distance];
end
shift = 0; 
figure 
hold on 

x = 1:length(data);
x = x/200; 
num_channels=[2 3 5 15 16];
for i = 1:length(num_channels) 
plot(x, data(i,:)/100 - shift); 
shift = shift + 50; 
hold on;
end 

y = find(sum(scors)~=0); 
scatter(x(y), 100*ones(1,length(y))); 
%plot(starts/200, 100*distances/max(distances)); 

h=hann(3*fs/step);
h=h/sum(h);
dist_smooth=conv(distances,h,'same');
hold on;
plot(starts/200, 100*dist_smooth/max(dist_smooth));
hold on;
MPD = ceil(win/step);%0;%
%dist_smooth=distances;
MPH=mean(dist_smooth);
[peaks,locs]=findpeaks(dist_smooth, 'MINPEAKDISTANCE', MPD, 'MINPEAKHEIGHT', MPH);
len=length(peaks);
adapt_borders=win+ locs*step;
scatter(adapt_borders/200, 100*dist_smooth(locs)/max(dist_smooth)); 

end