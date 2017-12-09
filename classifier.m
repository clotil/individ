function classifier(excerpts,bin_scors, K, channel)
% divide data into folds
for i=1:K
train_idx = 
test_idx = i;




train = FEATURES_ALL(train_idx,:);
test = FEATURES_ALL(test_idx,:);


% clessifier learning
Mdl = fitcnb(train,LABELS_ALL(train_idx));


% testing 
predict_labels = predict(Mdl, test);
test_labels = LABELS_ALL(test_idx);
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
