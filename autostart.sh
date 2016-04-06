#!/bin/bash

usage="$(basename "$0") [-n] [-a] [-h] -- program to set autostart of vm(s)

where:
    -h  show this help text
    -a  do for all vms (in xe vm-list)
    -n do for vm with name"

function all {
    VMS="$(xe vm-list | grep uuid | cut -d":" -f2 | cut -d" " -f2)"
    for vm in $VMS; do
        xe vm-param-set uuid="$vm" other-config:auto_poweron=true
    done
}

function add-vm {
    VM="$(xe vm-list | grep -B 1 -w $1 | grep uuid | cut -d":" -f2 | cut -d" " -f2)"
    echo $VM
    xe vm-param-set uuid="$VM" other-config:auto_poweron=true
}

while getopts ':han' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    a) all
       ;;
    n) for last; do true; done
       add-vm $last
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

