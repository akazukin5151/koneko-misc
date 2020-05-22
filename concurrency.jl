using Lazy

const tracker = Channel{String}(30)
const images = Channel{String}(30)
const path = @> "~/.local/share/koneko/cache/2232374/1" expanduser readdir(join=true, sort=false)

function consumer()
    try
        while true
            img = @> tracker take!
            @> images put!(img)
        end
    catch InvalidStateException
        @> images close
    end
end

function producer(files::Array{String})
    for file in files
        @> tracker put!(file)
    end
    @> tracker close
end

function display()
    left_shifts = [2, 20, 38, 56, 74]
    rowspaces = [0, 9]
    args = "--silent"  # Align doesn't work for some reason
    place = "--place=15x15@"
    try
        while true
            img = @> images take!
            number = @as x img begin
                split(x, "/")[end]
                split(x, "_")[1]
                parse(Int, x)
            end
            x = @> number mod(5)
            y = @> number div(5) mod(2)
            xcoord = left_shifts[x+1]
            ycoord = rowspaces[y+1]

            if number == 10
                @> "\n" repeat(40) println
            elseif number == 20
                @> "\n" repeat(18) println
            end

            @> `kitty +kitten icat $(args) $(place)$(xcoord)x$(ycoord) $img` run

        end
    catch InvalidStateException
        return
    end
end

function main(path)
    @async producer(path)
    @async consumer()
    display()
end

#using InteractiveUtils, Test
#@async producer(path)
#@async consumer()
#@inferred display()
#@code_warntype display()

main(path)

