function d = sigmoid_d(x)
  
    d = sigmoid(x) .* (1 - sigmoid(x));
end
