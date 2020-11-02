module Kwargs

include(joinpath(@__DIR__, "autodetect-dependabot.jl"))

function kwargs(; coverage::Bool, force_latest_compat::Union{Bool, Symbol})
    kwargs_dict = Dict{Symbol, Any}()
    kwargs[:coverage] = coverage
    if VERSION >= v"1.7.0-" # excludes 1.6, includes 1.7-DEV, includes 1.7
        if force_latest_compat isa Bool
            kwargs[:force_latest_compat] = force_latest_compat
        elseif force_latest_compat == :auto
            is_dependabot_job = AutodetectDependabot.is_dependabot_job()
            if is_dependabot_job
                @info("This is a Dependabot/CompatHelper job, so `force_latest_compat` has been set to `true`")
                kwargs[:force_latest_compat] = true
            else
                kwargs[:force_latest_compat] = false
            end
        else
            throw(ArgumentError("Invalid value for force_latest_compat: $(force_latest_compat)"))
        end
    else
        if force_latest_compat isa Bool
            @warn("The `force_latest_compat` option requires at least Julia 1.7", VERSION)
        end
    end
    return kwargs_dict
end

end # end module Kwargs
