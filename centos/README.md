# build CentOS images
https://github.com/moby/moby/blob/master/contrib/mkimage-yum.sh

$ sudo ./mkimage-yum.sh
> mkimage-yum.sh [OPTIONS] <name>
> OPTIONS:
>   -p "<packages>"  The list of packages to install in the container.
>                    The default is blank. Can use multiple times.
>   -g "<groups>"    The groups of packages to install in the container.
>                    The default is "Core". Can use multiple times.
>   -y <yumconf>     The path to the yum config to install packages from. The
>                    default is /etc/yum.conf for Centos/RHEL and /etc/dnf/dnf.conf for Fedora
>   -t <tag>         Specify Tag information.
>                    default is reffered at /etc/{redhat,system}-release
 
