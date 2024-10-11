% Define the function to integrate
f = @(x, y) x.^2 + y.^2; 


% Define the domain for the double integral
a = 0;   
b = 4;   
c = 0;   
d = 3;   


num_workers = 8; 

% Pre-allocate total integral variable
total_integral = 0;


for worker_idx = 1:num_workers
    % Compute the x subdomain for this worker
    x_start = a + (b - a) * (worker_idx - 1) / num_workers;
    x_end = a + (b - a) * worker_idx / num_workers;
    
    % Compute the integral over the subdomain
    local_integral = integral2(f, x_start, x_end, c, d);
    
    % Accumulate the results
    total_integral = total_integral + local_integral;
end


disp('Total integral (SPMD-style without parallel pool):');
disp(total_integral);
