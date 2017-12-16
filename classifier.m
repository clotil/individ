 function [FEATURES_ALL, LABELS_ALL, num_seg,koefs]=classifier(excerpts,bin_scors, channel)
% [FEATURES_ALL, LABELS_ALL, num_seg,koefs]
 % divide data into folds
num_of_exc=numel(fieldnames(excerpts));
FEATURES_ALL=[];
LABELS_ALL=[];
num_seg=[];
names_exc=fieldnames(excerpts);
names_bin=fieldnames(bin_scors);
koefs=[];
%set labels and features for all excerpts
prev_num_seg=0;
for i=1:num_of_exc
[cur_labels, cur_feat]=const_segmentation(excerpts.(names_exc{i}), bin_scors.(names_bin{i}),channel);
num_seg=[num_seg size(cur_feat,1)+(i-1)*prev_num_seg];
prev_num_seg=size(cur_feat,1);
FEATURES_ALL=[FEATURES_ALL; cur_feat];
LABELS_ALL=[LABELS_ALL; cur_labels.'];
end

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
    train_start=num_seg(i+1)+1;
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
    train_start2=num_seg(i+1)+1;
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
cur_koef=length(find(predict_labels == test_labels))/length(test_labels);
koefs=[koefs cur_koef];
end
end
% indices = crossvalind('Kfold', excerpts, K);
% for i=1:K
%     test_idx=(indices == i);
%     train_idx =~test_idx;
%     test_exc=excerpts(test_idx);
%     test_bin=bin_scors(test_idx);
%     [LABELS, FEATURES]=const_segmentation(test_exc, test_bin, channel);
%     M = size(FEATURES, 2);
%     Fidx = [];
%     for j=1:M
%     
%     end
%     Mdl = fitcnb(train,LABELS(train_ids));
%     
%     predict_labels = predict(Mdl, test);
%     test_labels = LABELS_ALL(test_ids);
% end
