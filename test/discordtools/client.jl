module test_discordtools_client

using Test
using DiscordTools

token = ""
c = Client(token)
@test !c.ready

add_command!(c, :echo; pattern=r"^echo (.+)") do c, msg, noprefix
    reply(c, msg, noprefix)
end

hs = get(c.handlers, Discord.MessageCreate, Dict())
@test collect(keys(hs)) == [:echo, :DJL_DEFAULT]
h = get(hs, :echo, nothing)
@test h.h.predicate.pattern == r"^echo (.+)"

delete_command!(c, :echo)

hs = get(c.handlers, Discord.MessageCreate, Dict())
@test collect(keys(hs)) == [:DJL_DEFAULT]

end # module test_discordtools_client
