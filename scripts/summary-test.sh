#!/bin/bash
echo script for Unit Test
echo '
    (o)--(o)
   /.______.\
   \________/
  ./        \.
 ( .        , )
  \ \_\\//_/ /
   ~~  ~~  ~~'
#Unit test with coverage
echo '====================='
echo Generating unit test
flutter test --coverage
echo Unit test completed
echo '====================='
#Generate report excluding folders
echo '      '
echo '====================='
echo Generating report
lcov -q --remove coverage/lcov.info 'lib/main.dart' 'lib/models/*' 'lib/repositories/*' 'lib/dependency_injections/*' 'lib/constants/*' 'lib/theme/*' 'lib/services/*' 'lib/routes/*'  'lib/app.dart' 'scripts/*'  -o coverage/full_lcov.info
#Pretty format
genhtml -q -o ./coverage coverage/full_lcov.info
echo Report created successfully
if [ "$1" == "open" ]; then
  open coverage/index.html
else
  echo If you want see coverage, type open coverage/index.html
fi
echo '====================='
