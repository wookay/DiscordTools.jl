module test_discordtools_client

using Test
using DiscordTools

token = ""
c = Client(token)
@test !c.ready

end # module test_discordtools_client
