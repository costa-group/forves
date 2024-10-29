#/bin/csh

foreach i (`ls /tmp/solc_*`)
 echo "$i `grep '[true|false]' $i | wc -l` `grep true $i | wc -l` `grep false $i | wc -l`"
end




