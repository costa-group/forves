#/bin/csh

foreach f (`find . -name "*.v"`)
  echo $f
  cat $f | sed s/Ctx/Exts/g > tmp
  mv -f tmp $f
end
