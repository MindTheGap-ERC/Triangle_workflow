using CarboKitten

using Unitful
using CarboKitten.Export: data_export, CSV
using HDF5

const PATH = "data/init_topo"

const TAG = "example_init_topo"

const FACIES = [
    ALCAP.Facies(
        viability_range=(4, 10),
        activation_range=(6, 10),
        maximum_growth_rate=500u"m/Myr",
        extinction_coefficient=0.8u"m^-1",
        saturation_intensity=60u"W/m^2",
        diffusion_coefficient=50.0u"m/yr"),
    ALCAP.Facies(
        viability_range=(4, 10),
        activation_range=(6, 10),
        maximum_growth_rate=400u"m/Myr",
        extinction_coefficient=0.1u"m^-1",
        saturation_intensity=60u"W/m^2",
        diffusion_coefficient=25.0u"m/yr"),
    ALCAP.Facies(
        viability_range=(4, 10),
        activation_range=(6, 10),
        maximum_growth_rate=100u"m/Myr",
        extinction_coefficient=0.005u"m^-1",
        saturation_intensity=60u"W/m^2",
        diffusion_coefficient=12.5u"m/yr")
]

const INPUT = ALCAP.Input(
    tag="$TAG",
    box=Box{Coast}(grid_size=(100, 50), phys_scale=150.0u"m"),
    time=TimeProperties(
        Δt=0.0001u"Myr",
        steps=5000,
        write_interval=1),
    ca_interval=1,
    initial_topography=(x, y) -> -x / 300.0,
    sea_level= 0.0u"m",
    subsidence_rate=50.0u"m/Myr",
    disintegration_rate=50.0u"m/Myr",
    insolation=400.0u"W/m^2",
    sediment_buffer_size=50,
    depositional_resolution=0.5u"m",
    facies=FACIES)

run_model(Model{ALCAP}, INPUT, "$(PATH)/$(TAG).h5")

function extract_topography(PATH,TAG)
    h5open("$(PATH)/$(TAG).h5", "r") do fid
        disintegration = read(fid["disintegration"])
        production = read(fid["production"])
        deposition = read(fid["deposition"])
        sediment_height = read(fid["sediment_height"])

        data = DataFrame(
            disintegration = disintegration,
            production = production,
            deposition = deposition,
            sediment_height = sediment_height
        )

        return data
end
end

extract_topography(PATH,TAG)
