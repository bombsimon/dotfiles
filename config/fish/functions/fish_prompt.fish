set fish_git_dirty_color     red
set fish_git_not_dirty_color yellow

function parse_git_branch
    set -l branch (git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
    set -l git_status (git status -s)

    if test -n "$git_status"
        echo (set_color $fish_git_dirty_color)"[$branch] "(set_color normal)
    else
      echo (set_color $fish_git_not_dirty_color)"[$branch] "(set_color normal)
  end
end

function fish_prompt
    if test $status -eq 0
        set_color yellow
    else
        set_color red
    end
    echo -n "><(((º> "

    set_color normal
    echo -n "- "

    set_color $fish_color_cwd
    echo -n (prompt_pwd)
    echo -n " "

    set -l git_dir (git rev-parse --git-dir 2> /dev/null)
    if test -n "$git_dir"
        echo -n (parse_git_branch)
    end
end
