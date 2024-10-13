#**************************************************************
# Create Clock
#**************************************************************
# Define the 125MHz external clock
create_clock -period 8 -name external_clk [get_ports CLOCK_125_p]

create_clock -period 5000000000 -name key0 [get_ports KEY[0]]

# Define the slower clock
create_generated_clock -name clk -source [get_ports CLOCK_125_p] -divide_by 2 [get_registers {baseline_c5gx:*|master:mstr|clock_div:divider|clk_div[1]}]

#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty