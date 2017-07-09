function fish_prompt
    set -l status_copy $status
    set -l color

    if test "$status_copy" -ne 0
        set color (set_color $fish_color_error)
    end

    if test 0 -eq (id -u "$USER")
        echo -sn "$color#: "
    end

    if test "$PWD" = ~
        echo -sn "$color~"
    else
        echo -sn "$color"(basename "$PWD")
    end

    echo -sn "$color_normal "
end
