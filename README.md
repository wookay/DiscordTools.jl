# DiscordTools.jl

|  **Build Status**                                                |
|:----------------------------------------------------------------:|
|  [![][travis-img]][travis-url]  [![][codecov-img]][codecov-url]  |


https://discordapp.com/developers/docs/

 * deps https://github.com/Xh4H/Discord.jl

```julia
julia> using Pkg; pkg"add https://github.com/Xh4H/Discord.jl.git"
julia> using Pkg; pkg"add https://github.com/wookay/DiscordTools.jl.git"
```

```julia
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

Base.JLOptions().isinteractive==0 && wait()
```


[travis-img]: https://api.travis-ci.org/wookay/DiscordTools.jl.svg?branch=master
[travis-url]: https://travis-ci.org/wookay/DiscordTools.jl

[codecov-img]: https://codecov.io/gh/wookay/DiscordTools.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/wookay/DiscordTools.jl/branch/master
