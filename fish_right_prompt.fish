function fish_right_prompt
    set -l nix_shell_info (
      if test "$IN_NIX_SHELL" = "1"
        echo -n " <nix>"
      end
    )
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
            set branch_name_len (string length $branch_name)
            set max_width (math (tput cols) / 5)
            if [ $branch_name_len -gt $max_width ]
                set start_pos (math $branch_name_len - $max_width)
                set branch_name (string sub -s $start_pos "$branch_name")
                set branch_name "...$branch_name"
            else
                set branch_name "$branch_name"
            end
        end

        echo -sn "$color_git$git_glyph$git_ahead$branch_name$color_normal$nix_shell_info"
    end
    mode_prompt
end

function mode_prompt --description "Display the default mode for the prompt"
    echo -n ' '
    # Do nothing if not in vi mode
    if test "$fish_key_bindings" = "fish_vi_key_bindings"
        or test "$fish_key_bindings" = "fish_hybrid_key_bindings"
        switch $fish_bind_mode
            case default
                set_color --bold --background red white
                echo ' '
            case insert
                set_color --bold --background cyan white
                echo ' '
            case replace_one
                set_color --bold --background red white
                echo ' '
            case visual
                set_color --bold --background magenta white
                echo ' '
        end
        set_color normal
    end
end
