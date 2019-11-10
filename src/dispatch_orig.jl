# module DiscordTools

using Discord: EVENT_TYPES, UnknownEvent, allhandlers, tryparse, priority, isexpired, dec!, predicate, logkws, handler, iscollecting, FallbackReason, FB_PREDICATE, fallback

# original code from https://github.com/Xh4H/Discord.jl/blob/master/src/gateway/gateway.jl#L303

# Dispatch an event to its handlers.
function dispatch_orig(c::Client, data::Dict)
    c.hb_seq = data[:s]
    T = get(EVENT_TYPES, data[:t], UnknownEvent)
    handlers = allhandlers(c, T)
    # If there are no handlers to call, don't bother parsing the event.
    isempty(handlers) && return

    evt = if T === UnknownEvent
        UnknownEvent(data)
    else
        val, e = tryparse(c, T, data[:d])
        if e === nothing
            val
        else
            T = UnknownEvent
            handlers = allhandlers(c, T)
            UnknownEvent(data)
        end
    end

    for (t, h) in sort(handlers; by=p -> priority(p.second), rev=true)
        # TODO: There are race conditions here.
        isexpired(h) && delete_handler!(c, eltype(h), tag)
        dec!(h)

        pred = try
            predicate(h)(c, evt)
        catch e
            kws = logkws(c; event=T, handler=t, exception=(e, catch_backtrace()))
            @warn "Predicate function threw an exception" kws...
            return  # Predicate throws -> do nothing.
        end

        if pred === true
            try
                result = handler(h)(c, evt)
                iscollecting(h) && push!(results(h), result)
            catch e
                kws = logkws(c; event=T, handler=t, exception=(e, catch_backtrace()))
                @warn "Handler function threw an exception" kws...
            end
        else
            reason = pred in instances(FallbackReason) ? pred : FB_PREDICATE
            try
                fallback(h, reason)(c, evt)
            catch e
                kws = logkws(c; event=T, handler=t, exception=(e, catch_backtrace()))
                @warn "Fallback function threw an exception" kws...
            end
        end
    end
end

# module DiscordTools
