function fish_prompt
    echo
    set_color normal
    echo -n 'emerick @ '
    set_color green
    echo -n 'ubuntu'
    set_color normal
    echo -n ' ('
    echo -n (date +%FT%T+02:00)
    echo -n ') '
    set_color blue
    echo (prompt_pwd)
    set_color normal
    echo -n '> '
end
