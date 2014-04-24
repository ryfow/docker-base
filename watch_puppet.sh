#!/bin/bash
while true
do
  puppet apply /var/lib/puppet/site.pp
  inotifywait -e close_write,moved_to,create /var/lib/puppet
done