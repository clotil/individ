function CUR_FEAT=feature_extraction_multi_channel(segment)
channels=size(segment,1);
del=[0, 4];
thet=[4, 8];
al=[8, 13];
bet=[13, 30];
all = [0 30];
fs=200;
MN=mean(segment,2);
STaD=std(segment,0,2);
MAX=max(segment, [],2);
MIN=min(segment, [],2);
SKEW=skewness(segment, 1, 2);
KURT=kurtosis(segment,1,2);
MD=median(segment,2);
ALPHA=[];
BETA=[];
DELTA=[];
THETA=[];
rel=[];

for i=1:channels
cur_alpha=bandpower(segment(i,:), fs, al);
ALPHA=[ALPHA cur_alpha];
cur_beta=bandpower(segment(i,:), fs, bet);
BETA=[BETA cur_beta];
cur_delta=bandpower(segment(i,:), fs, del);
DELTA=[DELTA cur_delta];
cur_theta=bandpower(segment(i,:), fs, thet);
THETA=[THETA cur_theta];
cur_rel = [cur_alpha cur_beta cur_delta cur_theta]/bandpower(segment(i,:), fs, all);
rel=[rel cur_rel];
end
MN=MN';
STaD=STaD';
MAX=MAX'; 
MIN=MIN';
SKEW=SKEW'; 
KURT=KURT'; 
MD=MD';

CUR_FEAT = [MN STaD MAX MIN SKEW KURT MD ALPHA BETA DELTA THETA rel];  
end