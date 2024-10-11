% Define the function to integrate
f = @(x, y) x.^2 + y.^2;  

% Define the domain for the double integral
a = 20;   
b = 40;   
c = 50;   
d = 70;   

num_workers = 8;  

%serial Execution (No Parallelization)
disp('Starting serial execution...');
tic;  


total_integral_serial = 0;
for worker_idx = 1:num_workers
    x_start = a + (b - a) * (worker_idx - 1) / num_workers;
    x_end = a + (b - a) * worker_idx / num_workers;
    local_integral = integral2(f, x_start, x_end, c, d);
    total_integral_serial = total_integral_serial + local_integral;
end

serial_time = toc;  % End timing for serial execution
disp(['Serial execution time: ', num2str(serial_time), ' seconds']);
disp(['Total integral (Serial): ', num2str(total_integral_serial)]);


disp('Starting parallel execution...');
tic;  


spmd
    % Divide the x-domain among workers
    x_start = a + (b - a) * (spmdIndex - 1) / spmdSize;
    x_end = a + (b - a) * spmdIndex / spmdSize;
    
    % Compute the integral for this worker's subdomain
    local_integral = integral2(f, x_start, x_end, c, d);
    
    % Sum up the results across all workers
    total_integral_parallel = spmdPlus(local_integral);
end

parallel_time = toc;  % End timing for parallel execution
disp(['Parallel execution time: ', num2str(parallel_time), ' seconds']);
disp(['Total integral (Parallel): ', num2str(total_integral_parallel{1})]);

speedup = serial_time / parallel_time;
efficiency = speedup / num_workers;

disp(['Speedup: ', num2str(speedup)]);
disp(['Efficiency: ', num2str(efficiency)]);
