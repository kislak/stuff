if [ $(/usr/bin/groups $USER| grep -c  %nasadmin%) == 1 ] ; then
  bash "$@"
else
  echo "Connection refused:"
  echo "Please configure this account as an Administrator to use this service"
fi
