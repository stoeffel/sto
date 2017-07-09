function fish_right_prompt
    set -l status_copy $status
    set -l status_code $status_copy

    set -l color_git (set_color cyan)
    set -l color_normal (set_color normal)
    set -l color_error (set_color $fish_color_error)
    set -l color "$color_normal"

    switch "$status_copy"
        case 0 "$__sto_status_last"
            set status_code
    end

    set -g __sto_status_last $status_copy

    if test "$status_copy" -ne 0
        set color "$color_error"
    end

    if test "$CMD_DURATION" -gt 250
        set -l duration (echo $CMD_DURATION | humanize_duration)
        echo -sn "$color($duration)$color_normal "
    end

    if set branch_name (git_branch_name)
        set -l git_glyph

        if git_is_staged
            if git_is_dirty
                set git_glyph "*"
            else
                set git_glyph "+"
            end
        else if git_is_dirty
            set git_glyph "*"

        else if git_is_touched
            set git_glyph "*"
        end

        set -l git_ahead (git_ahead "↑" "↓" "↑↓")

        if test "$branch_name" = "master"
            set branch_name
        else
            set branch_name "$branch_name"
        end

        echo -sn "$color_git$git_glyph $branch_name$git_ahead$color_normal"
    end

end
