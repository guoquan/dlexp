function [ bp ] = getBatchBPCost
bp.f = @(h,y,~,~) (sum(sum((y-h).^2))./(2*size(y,2)));
bp.d = @(h,y,~,~,~) (- (y - h) ./ size(y,2));
end
