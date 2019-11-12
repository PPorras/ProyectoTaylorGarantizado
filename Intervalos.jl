module Intervalos

export Intervalo

struct Intervalo <: Real
    inf::Float64
    sup::Float64
    #function Intervalo(inf, sup)
	#   @assert inf <= sup
	function Intervalo(inf,sup)
		if inf == Nothing
			new(nothing, nothing) 
		elseif inf > sup 
			error("No es un intervalo valido") 
		else
			new(inf,sup)
		end
	end
	#    new(inf,sup)
	#end
end


Intervalo(a) = Intervalo(a,a)

import Base: show, +, -,*, /, ^, exp, sqrt, one

function show(io::IO, X::Intervalo) 
    println(io, "I",[X.inf, X.sup])
end

one(::Intervalo) = Intervalo(1.0,1.0)

function +(x::Intervalo, y::Intervalo)
    return Intervalo(x.inf + y.inf, x.sup + y.sup)
end

function +(x::Intervalo, c::Real) 
    # Aquí definimos la suma de un Intervalo a un Real
    return Intervalo(x.inf + c, x.sup + c)
end

function +(c::Real, x::Intervalo)
    # Aquí definimos la suma de un Real a un Intervalo
    return Intervalo(x.inf + c, x.sup + c)
end


function -(x::Intervalo)
    return Intervalo(- x.sup, - x.inf)
end

function -(x::Intervalo, y::Intervalo)
    y = -y
    return Intervalo(x.inf + y.inf, x.sup + y.sup)
end

function -(x::Intervalo, c::Real)
    return Intervalo(x.inf - c, x.sup - c)
end

function -(c::Real, x::Intervalo)
	 c + (-x)
    #return Intervalo(c-x.inf, c-x.sup)
end


function *(x::Intervalo, y::Intervalo)
    Intervalo(min(x.inf*y.inf, x.sup*y.inf, x.sup*y.sup, x.inf*y.sup), 
        max(x.inf*y.inf, x.sup*y.inf, x.sup*y.sup, x.inf*y.sup))
end

function *(x::Intervalo, c::Real)
    Intervalo(min(x.inf*c, x.sup*c), max(x.inf*c, x.sup*c))
    
    #return Intervalo(x.inf * c, x.sup * c)
end

function *(c::Real, x::Intervalo)
    Intervalo(min(x.inf*c, x.sup*c), max(x.inf*c, x.sup*c))
end

function /(x::Intervalo, y::Intervalo)
    if sign(y.inf) != sign(y.sup) && y.inf != 0.0 && y.sup != 0.0
        Intervalo(-Inf, Inf)
    elseif y.inf == 0.0
        Intervalo(min(x.inf/y.sup, x.sup/y.sup), Inf)
    elseif y.sup == 0.0
        Intervalo(-Inf, max(x.inf/y.inf, x.sup/y.inf))
    else
        Intervalo(min(x.inf/y.inf, x.inf/y.sup, x.sup/y.inf, x.sup/y.sup), 
            max(x.inf/y.inf, x.sup/y.inf, x.sup/y.sup, x.inf/y.sup))
    end
end

function /(x::Intervalo, c::Real)
    Intervalo(min(x.inf/c, x.sup/c), max(x.inf/c, x.sup/c))
    
    #return Intervalo(x.inf * c, x.sup * c)
end

function /(c::Real, x::Intervalo)
    if sign(x.inf) != sign(x.sup) && x.inf != 0.0 && x.sup != 0.0
        Intervalo(-Inf, Inf)
    elseif x.inf == 0.0
        Intervalo(c/x.sup, Inf)
    elseif x.sup == 0.0
        Intervalo(-Inf, c/x.inf)
    else
        Intervalo(min(c/x.inf, c/x.sup), max(c/x.inf, c/x.sup))
    end
end


function ^(x::Intervalo, c::Int64)
    if iseven(c)
        if x.inf < 0 && x.sup >0
            if abs(x.inf) < abs(x.sup)
                return Intervalo(0, x.sup^c)
            else
                return Intervalo(0, x.inf^c)
            end
        elseif x.inf < 0 && x.sup < 0
             return Intervalo(x.sup^c, x.inf^c)
        else
            return Intervalo(x.inf^c, x.sup^c)
        end
    else
        Intervalo(x.inf^c, x.sup^c)
    end
end

function exp(x::Intervalo)
    Intervalo(exp(x.inf),exp(x.sup))
end

function sqrt(x::Intervalo)
    if x.inf < 0 || x.sup < 0
        Intervalo(0,0)
    else
        Intervalo(sqrt(x.inf), sqrt(x.sup))
    end
end

end
