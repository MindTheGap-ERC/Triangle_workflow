using CarboKitten

using Unitful
using Interpolations
using CarboKitten.Visualization
using CarboKitten.Visualization: summary_plot
using GLMakie

using DelimitedFiles
OUTPUTDIR = "grid_scan"

using CarboKitten.Boxes: Box, Coast

using CarboKitten.Config: TimeProperties
using CarboKitten.Components.TimeIntegration: write_times

function initial_topography(x, y)
	return -x / 300.0
end

const PERIOD = 0.2u"Myr"
const AMPLITUDE = 4.0u"m"

# Make a list of boxes with different sizes

list_boxes = [(x::Int, y::Int) for x in 50:10:100, y in 50:10:100]

function main(box_size::Tuple)
	box = Box{Coast}(grid_size = box_size, phys_scale = 100.0u"m")

	time = TimeProperties(
		Δt = 200u"yr",
		steps = 2000
	)

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
		tag = "sinusoid, $(Boxes)",
		
		time = time,
		box = box,
		facies = facies,
		sea_level=t -> AMPLITUDE * sin(2π * t / PERIOD),
		initial_topography = initial_topography,
		
		subsidence_rate = 50.0u"m/Myr",
		insolation = 400.0u"W/m^2",
		
		sediment_buffer_size = 50,
		depositional_resolution = 0.5u"m",
		
		disintegration_rate = 50.0u"m/Myr"
	)

	# Save output and figure for each combination of the grid size

	output = "Box_$(box_size[1])_$(box_size[2])"
	run_model(Model{ALCAP}, input, "$(OUTPUTDIR)/$(output).h5")
	save("$(OUTPUTDIR)/$(output).png", summary_plot("$(OUTPUTDIR)/$(output).h5"))
end


for size in list_boxes
    main(size)
end