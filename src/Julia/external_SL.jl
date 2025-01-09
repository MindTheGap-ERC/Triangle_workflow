using CarboKitten

using Unitful

using DelimitedFiles
OUTPUTDIR = ".temp"

# Create a simulation box
using CarboKitten.Boxes: Box, Coast

box = Box{Coast}(grid_size = (50, 50), phys_scale = 300.0u"m")

# Define simulation time
using CarboKitten.Config: TimeProperties
using CarboKitten.Components.TimeIntegration: write_times

time = TimeProperties(
	Δt = 500u"yr",
	steps = 2000
)

# Initial topography

function initial_topography(x, y)
	return -x / 300.0
end

# Import sea level curve

dir = "data/sea-level_curves"
filename = joinpath(dir, "Auto000_Allo000_Stoch100V1.txt")
input_sl = readdlm(filename, '\t', header=false)

# the sea level file has a different length than the duration set for the run. 
# this is a case when the time step matches but the durations don't, so we truncate the file. This needs to be made more error-proof.

input_sl_array = input_sl[1:time.steps+1, 1].* u"m"

using Interpolations

sea_level = linear_interpolation(0*time.Δt:time.Δt:time.steps*time.Δt, input_sl_array);

# Facies definitions

facies = [
	ALCAP.Facies(
		maximum_growth_rate = 500.0u"m/Myr",
		extinction_coefficient = 0.8u"m^-1",
		saturation_intensity = 60.0u"W/m^2",
		diffusion_coefficient = 500u"m"
	),
	ALCAP.Facies(
		maximum_growth_rate = 400.0u"m/Myr",
		extinction_coefficient = 0.1u"m^-1",
		saturation_intensity = 60.0u"W/m^2",
		diffusion_coefficient = 5000u"m"
	),
	ALCAP.Facies(
		maximum_growth_rate = 100.0u"m/Myr",
		extinction_coefficient = 0.005u"m^-1",
		saturation_intensity = 60.0u"W/m^2",
		diffusion_coefficient = 3000u"m"
	)]

    input = ALCAP.Input(
	tag = "external_SL",
	
	time = time,
	box = box,
	facies = facies,
	sea_level = sea_level,
	initial_topography = initial_topography,
	
	subsidence_rate = 50.0u"m/Myr",
	insolation = 400.0u"W/m^2",
	
	sediment_buffer_size = 50,
	depositional_resolution = 0.5u"m",
	
	disintegration_rate = 50.0u"m/Myr"
)

output = run_model(Model{ALCAP}, input, "$(OUTPUTDIR)/external_SL.h5")