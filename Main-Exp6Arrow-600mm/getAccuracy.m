% Caculate correct numbers and accuracy
function [numCorrect, accuracy] = getAccuracy(digitOriginal, digitResponse)

numCorrect = 0;
for i = 1:length(digitOriginal)
    if digitOriginal(i) == digitResponse(i)
       numCorrect = numCorrect + 1;
    end
end
accuracy = numCorrect / length(digitOriginal);

