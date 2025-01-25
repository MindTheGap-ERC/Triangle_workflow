using CarboKitten

using Unitful
using Interpolations
using CarboKitten.Visualization
using CarboKitten.Visualization: summary_plot
using GLMakie

using DelimitedFiles
OUTPUTDIR = "dimension_scan"

using CarboKitten.Boxes: Box, Coast

using CarboKitten.Config: TimeProperties
using CarboKitten.Components.TimeIntegration: write_times

function initial_topography(x, y)
	return -x / 300.0
end

const PERIOD = 0.2u"Myr"
const AMPLITUDE = 4.0u"m"

function main(scale)
	box = Box{Coast}(grid_size = (100, 70), phys_scale = scale * u"m")

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
		tag = "sinusoid, dimension $(scale)",
		
		time = time,
		box = box,
		facies = facies,
		sea_level=t -> AMPLITUDE * sin(2π * t / PERIOD),
		initial_topography = initial_topography,
		
		subsidence_rate = 25.0u"m/Myr",
		insolation = 400.0u"W/m^2",
		
		sediment_buffer_size = 50,
		depositional_resolution = 0.5u"m",
		
		disintegration_rate = 50.0u"m/Myr"
	)

	# Save output and figure for each combination of the grid size

	output = "Phys_dim_$(scale)"
	run_model(Model{ALCAP}, input, "$(OUTPUTDIR)/$(output).h5")
	save("$(OUTPUTDIR)/$(output).png", summary_plot("$(OUTPUTDIR)/$(output).h5"))
end


for scale in 50:20:300
    main(scale)
end
