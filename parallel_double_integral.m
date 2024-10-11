% Define the function to integrate
f = @(x, y) x.^2 + y.^2;  

% Define the domain for the double integral
a = 0;   
b = 4;   
c = 0;   
d = 3;   


num_subdomains = 10;  


total_integral = 0;


dx = (b - a) / num_subdomains;

% 
if isempty(gcp('nocreate'))  
    parpool;  
end

% Pre-allocate array to store local integrals from each worker
local_integrals = zeros(1, num_subdomains);


parfor i = 1:num_subdomains
    % Define the x-domain for the current subdomain
    x_start = a + (i - 1) * dx;
    x_end = a + i * dx;
    
    % Compute the integral over the current subdomain
    local_integrals(i) = integral2(f, x_start, x_end, c, d);
end


total_integral = sum(local_integrals);

disp('Total integral (parfor):');
disp(total_integral);

delete(gcp('nocreate'));

