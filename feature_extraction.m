function CUR_FEAT=feature_extraction(segment)
MN=mean(segment);
STaD=std(segment);
MAX=max(segment);
MIN=min(segment);
SKEW=skewness(segment);
KURT = kurtosis(segment);
MD=median(segment);
FourTransf=fft(segment);
ABS_FFT=abs(FourTransf);
del=[0, 4];
thet=[4, 8];
al=[8, 13];
bet=[13, 30];
fs=200;
%data=linspace(1, size(ABS_FFT,1));
ALFA=bandpower(ABS_FFT, fs, al);
BETA=bandpower(ABS_FFT, fs, bet);
DELTA=bandpower(ABS_FFT, fs, del);
THETA=bandpower(ABS_FFT, fs, thet);
CUR_FEAT = [MN STaD MAX MIN SKEW KURT MD ALFA BETA DELTA THETA];  
end