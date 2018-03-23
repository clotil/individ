function [accur, prec, rec, spec, npv, fm]=classifier_adapt(excerpts,bin_scors, settings)
% [FEATURES_ALL, LABELS_ALL, num_seg,koefs]
 % divide data into folds
num_of_exc=numel(fieldnames(excerpts));
FEATURES_ALL=[];
LABELS_ALL=[];
num_seg=[];
names_exc=fieldnames(excerpts);
names_bin=fieldnames(bin_scors);
accur=[];
prec=[];
rec=[];
spec=[];
npv=[];
fm=[];
%set labels and features for all excerpts
all_num_seg=[];
for i=1:num_of_exc
[cur_labels, cur_feat]=adapt_segmentation(excerpts.(names_exc{i}), bin_scors.(names_bin{i}),settings);
all_num_seg=[all_num_seg size(cur_feat,1)];
FEATURES_ALL=[FEATURES_ALL; cur_feat];
LABELS_ALL=[LABELS_ALL; cur_labels.'];
end
prev_num_seg=0;
for i=1:num_of_exc
    num_seg=[num_seg all_num_seg(i)+prev_num_seg];
    prev_num_seg=prev_num_seg+all_num_seg(i);
end
max_cur=max(num_seg);
for i=1:num_of_exc

%set test data
if (i==1)
    test_idx_start=1;
else
test_idx_start=num_seg(i-1)+1;
end
test_idx_end=num_seg(i);
test_labels=LABELS_ALL(test_idx_start:test_idx_end,1);
test_features=FEATURES_ALL(test_idx_start:test_idx_end,:);
%set train data
if(i==1)
    
    train_start=num_seg(i)+1;
    train_end=size(FEATURES_ALL,1);
    train_features=FEATURES_ALL(train_start:train_end, :);
    train_labels=LABELS_ALL(train_start:train_end,1);
    
elseif (i==num_of_exc)
     train_start=1;
     train_end=num_seg(i-1);
     train_features=FEATURES_ALL(train_start:train_end, :);
     train_labels=LABELS_ALL(train_start:train_end,1);
    
else 
    train_start1=1;
    train_end1=num_seg(i-1);
    train_start2=num_seg(i)+1;
    train_end2=size(FEATURES_ALL,1);
    train_features1=FEATURES_ALL(train_start1:train_end1, :);
     train_labels1=LABELS_ALL(train_start1:train_end1,1);
     train_features2=FEATURES_ALL(train_start2:train_end2, :);
     train_labels2=LABELS_ALL(train_start2:train_end2, 1);
     train_features=[train_features1; train_features2];
     train_labels=[train_labels1;train_labels2];
     
end

% clessifier learning
Mdl = fitcnb(train_features,train_labels);


% testing 
predict_labels = predict(Mdl, test_features);

cur_accur=length(find(predict_labels == test_labels))/length(test_labels);
accur=[accur cur_accur];
truepositive=length(find(test_labels==1 & predict_labels==test_labels));
falsepositive=length(find(predict_labels==1 & predict_labels~=test_labels));
truenegative=length(find(test_labels==0 & predict_labels==test_labels));
falsenegative=length(find(predict_labels==0 & predict_labels~=test_labels));
cur_prec=truepositive/(truepositive+falsepositive);
cur_rec=truepositive/(truepositive+falsenegative);
cur_spec=truenegative/(truenegative+falsepositive);
cur_npv=truenegative/(truenegative+falsenegative);
cur_fm=2*(cur_prec*cur_rec)/(cur_prec+cur_rec);
prec=[prec cur_prec];
spec=[spec cur_spec];
rec=[rec cur_rec];
npv=[npv cur_npv];
fm=[fm cur_fm];
end
prec(isnan(prec))=0;
spec(isnan(spec))=0;
rec(isnan(rec))=0;
npv(isnan(npv))=0;
fm(isnan(fm))=0;
accur(isnan(accur))=0;
end