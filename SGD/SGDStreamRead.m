function [ data, flag ] = SGDStreamRead( stream, flag, n, count )

if isempty(n) || n <= 0
    if flag == 0
        % stream preserve mode
        data = stream;
    else
        % back to stream storage
        data = stream; 
    end
	return;
end

% basic reader sample
try
    count = size(stream, 2);
    data = stream(:, (flag + 1):(min(flag + n, count)));
    flag = flag + n;
    while(flag >= count)
        n = flag - count;
        flag = 0;
        data = cat(2, data, stream(:, (flag + 1):(min(flag + n, count))));
        flag = flag + n;
    end
catch err
    disp(err);
end
end

