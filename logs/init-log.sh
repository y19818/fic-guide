if [ ! -f "/usr/local/bin/pause" ]; then
  sudo echo "#! /bin/bash
  get_char()
  {
    SAVEDSTTY=\`stty -g\`
    stty -echo
    stty raw
    dd if=/dev/tty bs=1 count=1 2> /dev/null
    stty -raw
    stty echo
    stty \$SAVEDSTTY
   }
   if [ -z '$1' ]; then
    echo ' '
    echo -e '\033[34m Please press any key to continue... \033[0m'
    echo ' '
   else
    echo -e '$1'
   fi
   get_char
   " > /usr/local/bin/pause;

   sudo chmod 0755 /usr/local/bin/pause;
fi