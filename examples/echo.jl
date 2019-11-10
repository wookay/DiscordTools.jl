using DiscordTools

token = get(ENV, "DISCORD_TOKEN", "")
isempty(token) && throw("DISCORD_TOKEN is empty")
c = Client(token)
open(c)
@info :c c

@async wait(c)

add_command!(c, :echo; pattern=r"^echo (.+)") do c, msg, noprefix
    reply(c, msg, noprefix)
end

# delete_command!(c, :echo)

#=
function Discord.dispatch(c::Client, data::Dict)
    @info :dispatch data
    dispatch_orig(c, data)
end
=#

Base.JLOptions().isinteractive==0 && wait()
