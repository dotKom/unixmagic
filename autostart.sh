#!/bin/bash

usage="$(basename "$0") [-a] [-h] vm-name -- program to set autostart of vm(s)

where:
    -h  show this help text
    -a  do for all vms (in xe vm-list)"

while getopts ':hs:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    s) seed=$OPTARG
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

function add-all {
    VMS="$(xe vm-list | grep uuid | cut -d":" -f2)"
    for vm in VMS; do
        echo $vm
    done
}

function add-vm {
    VM="$(xe vm-list | grep -B 1 -w $1 | grep uuid | cut -d":" -f2)"
    echo $VM
}
