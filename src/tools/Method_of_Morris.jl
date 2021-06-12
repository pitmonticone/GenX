"""
GenX: An Configurable Capacity Expansion Model
Copyright (C) 2021,  Massachusetts Institute of Technology
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
A complete copy of the GNU General Public License v2 (GPLv2) is available
in LICENSE.txt.  Users uncompressing this from an archive may not have
received this license file.  If not, see <http://www.gnu.org/licenses/>.
"""

@doc raw"""
	morris(EP::Model, path::AbstractString, setup::Dict, inputs::Dict, outpath::AbstractString)

We are in the process of implementing Method of Morris for global sensitivity analysis
"""
function mga(EP::Model, path::AbstractString, setup::Dict, inputs::Dict, outpath::AbstractString)

    Morris_range = CSV.read(string(path, "/Method_of_morris_range.csv"), header=true)

    f1 = function(p)
        print(p)
        myinputs["dfGen"][!,:Inv_Cost_per_MWyr]=p
        EP = generate_model(mysetup, myinputs, OPTIMIZER)
        EP, solve_time = solve_model(EP, mysetup)
        [objective_value(EP)]
    end

    A = myinputs["dfGen"][!,:Inv_Cost_per_MWyr]
    B = myinputs["dfGen"][!,:sigma]
    C = [A B]
    C = mapslices(x->[x], C, dims=2)[:]
    m = gsa(f1,Morris(total_num_trajectory=10,num_trajectory=3),C)
end
