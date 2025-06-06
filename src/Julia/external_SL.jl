using CarboKitten

using Unitful
using Interpolations

using DelimitedFiles

using CarboKitten.Boxes: Box, Coast

using CarboKitten.Config: TimeProperties
using CarboKitten.Components.TimeIntegration: write_times

using CarboKitten.Export: data_export, CSV

function initial_topography(x, y)
	return -x / 300.0
end

function main()
	box = Box{Coast}(grid_size = (100, 70), phys_scale = 170.0u"m")

	time = TimeProperties(
		Δt = 200u"yr",
		steps = 2000
	)

	# Import sea level curve
	input_sl = readdlm(ARGS[1], '\t', header=false) * u"m"
	sea_level = input_sl[1:2001,1]

	SL  = linear_interpolation(time_axis(time), sea_level)

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
		sea_level = SL,
		initial_topography = initial_topography,
		
		subsidence_rate = 50.0u"m/Myr",
		insolation = 400.0u"W/m^2",
		
		sediment_buffer_size = 50,
		depositional_resolution = 0.5u"m",
		
		disintegration_rate = 50.0u"m/Myr"
	)

	run_model(Model{ALCAP}, input, "$(ARGS[2])")

	# Export sections at 4, 8 and 12 km away from the shore
	export_locations = [(23, 35), (47, 35), (71, 35)]
	data_export(CSV(export_locations,
	:stratigraphic_column => "$(ARGS[3])",
	:metadata => "$(ARGS[4])"),
	"$(ARGS[2])")
end

main()