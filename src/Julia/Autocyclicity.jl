module Script

using Unitful
using CarboKitten
using CarboKitten.Models: WithoutCA as mod
using CarboKitten.Transport
using GLMakie
using HDF5
using CarboKitten.Export: read_slice
using CarboKitten.Visualization: sediment_profile, stratigraphic_column!
using CarboKitten.Visualization

const PATH = "data"

const TAG = "WithoutCA"

const FACIES = [
    mod.Facies(
        # viability_range = (4, 10),
        # activation_range = (6, 10),
        maximum_growth_rate=500u"m/Myr",
        extinction_coefficient=0.8u"m^-1",
        saturation_intensity=60u"W/m^2",
        diffusion_coefficient=50.0u"m/yr"),
    mod.Facies(
        # viability_range = (4, 10),
        # activation_range = (6, 10),
        maximum_growth_rate=400u"m/Myr",
        extinction_coefficient=0.1u"m^-1",
        saturation_intensity=60u"W/m^2",
        diffusion_coefficient=25.0u"m/yr"),
    mod.Facies(
        # viability_range = (4, 10),
        # activation_range = (6, 10),
        maximum_growth_rate=100u"m/Myr",
        extinction_coefficient=0.005u"m^-1",
        saturation_intensity=60u"W/m^2",
        diffusion_coefficient=12.5u"m/yr")
]

const INPUT = mod.Input(
    tag="$TAG",
    box=CarboKitten.Box{Coast}(grid_size=(100, 50), phys_scale=150.0u"m"),
    time=TimeProperties(
        Δt=0.0002u"Myr",
        steps=5000,
        write_interval=1),
    initial_topography=(x, y) -> -x / 300.0,
    sea_level= _ -> 0.0u"m",
    subsidence_rate=50.0u"m/Myr",
    disintegration_rate=50.0u"m/Myr",
    insolation=400.0u"W/m^2",
    sediment_buffer_size=50,
    depositional_resolution=0.5u"m",
    facies=FACIES)

function main()
    withoutCA = run_model(Model{mod}, INPUT, "$(PATH)/$(TAG).h5")
    save("data/$(TAG).png",summary_plot("$(PATH)/$(TAG).h5"))
    return withoutCA
end

function extract_sed_height()
    run = h5open("$(PATH)/$(TAG).h5", "r")
    sed_height = read(run["sediment_height"])
    close(run)
    return sed_height
end

sed_height = extract_sed_height()

function plot_heatmap(height)
    fig = Figure()
    ax = Axis(fig[1, 1], title = "Sediment Height: $(height)", xlabel = "X", ylabel = "Y")
    map = heatmap!(ax, sed_height[:,:,height], colormap = :viridis)
    Colorbar(fig[1, 2], map, label = "Sediment Height")
    save("data/withoutCA_surface_$(height).png", fig)
end

plot_heatmap(3500)

save("data/sediment_profile.png",
    sediment_profile(read_slice("data/WithoutCA.h5", :, 25)...))

function plot_line(sed_height, path, y)
    fig = Figure()
    ax = Axis(fig[1, 1], title="Sediment Height at y = $(y) [m]", xlabel="Index", ylabel="Height")
    sed_height[:, 1, :]
    lines!(ax, 1:size(sed_height, 1), sed_height[:, y, 5001], color=:blue, linewidth=2)
    save(path, fig)
end

plot_line(sed_height, "data/sed_height_25.png", 25)

end   
Script.main()
