load('swarmalator_identical_N_100_K_-0.5_J_0.8_g1_0.67_g2_-0.33.mat')
test = y_full(101:end,:);

traningData = [];
for i = 1:size(test,1)
   data = test(i,:);
   index = phaseSeparation(data);
   data = [reshape(data,[],3),index'];
   traningData(i,:,:) = data;
end
newTest = reshape(traningData(1,:,:),[],4);
