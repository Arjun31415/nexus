
# Author: Arjun31415
# Date: 2022-02-19
# Set the mode of the bar to either info or visualizer mode.
# mode 0: info mode, the default mode
# mode 1: visualizer mode
# /tmp/waybar_music_mode: is the file that stores the mode and the value in
#                         it is used to appropriately set the mode
# the file is polled every 1 sec

mode0_cmd="python $HOME/.config/waybar/scripts/mediaplayer.py"
mode1_cmd="$HOME/.config/waybar/scripts/waybar-cava.sh"
CURRENT_MODE=2
child_pid=""
check_mode() {
    # check if file is empty first
    if [[ ! -s /tmp/waybar_music_mode ]]; then
        # set the mode to default
        echo "0" >/tmp/waybar_music_mode
        return 0
    fi

    WAYBAR_MUSIC_COMP_MODE=$(cat /tmp/waybar_music_mode)
    if [[ $WAYBAR_MUSIC_COMP_MODE == 1 ]]; then
        # echo "visualixer mode"
        return 1
    else
        # echo "info mode"
        return 0
    fi
}
run_mode() {

    mode=$1
    if [[ $mode == "$CURRENT_MODE" ]]; then
        # the current mode is running, just return
        return 0
    elif [[ $mode == 0 ]]; then
        kill $child_pid
        CURRENT_MODE=0
        exec $mode0_cmd &
        # get the PID of the child command executed above
        child_pid=$!
    else
        kill $child_pid
        CURRENT_MODE=1
        exec $mode1_cmd &
        # get the PID of the child command executed above
        child_pid=$!
    fi

}
while true; do
    check_mode
    # get the return value
    x=$?
    run_mode $x
    sleep 1
done

