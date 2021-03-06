x = 1:.2:10*pi; a = rand(1,length(x)); b = 1:8;
y = zeros(8,length(x));
for i = 1:length(b)
    y(i,:) =(...
        (3*sin(1.0*x)+3*rand(1,length(x))) + ...
        (2*sin(1.8*x)+3*rand(1,length(x))) + ...
        (2*sin(4.1*x)+3*rand(1,length(x))))...
        +(15*b(i)-10);    
end

figure; hold on;
for i = 1:length(b)
    plot(y(i,:))
end

xlabel('sample')
ylabel('channel')
