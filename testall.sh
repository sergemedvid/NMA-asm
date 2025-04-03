#!/bin/zsh

# Prepare CSV file
echo "Directory,ORIG,STD,ADV,BIG,CUST,Size" > results.csv

# Loop through immediate subdirectories matching KA-*
for dir in KA-*/; do
  if [[ -d "$dir" ]]; then
    echo "Entering $dir"
    (
      cd "$dir" || exit
      rm -f RESULT.TXT
      gtimeout --signal=SIGKILL 5s dosbox-x \
        -set "cpu cycles=407000" \
        -c "mount c ~/Documents/projects/UKMA/2025/KA/_TASM" \
        -c "mount d ." \
        -c "mount e ../_mserge/NMA-asm/" \
        -c "SET PATH=C:\\TASM" \
        -c "CALL E:\TESTDATA\AUTOPREP.BAT" \
        -c "CALL E:\TESTDATA\AUTOORIG.BAT" \
        -c "CALL E:\TESTDATA\AUTOCLN.BAT" \
        2&> /dev/null 
      gtimeout --signal=SIGKILL 10s dosbox-x \
        -set "cpu cycles=407000" \
        -c "mount c ~/Documents/projects/UKMA/2025/KA/_TASM" \
        -c "mount d ." \
        -c "mount e ../_mserge/NMA-asm/" \
        -c "SET PATH=C:\\TASM" \
        -c "CALL E:\TESTDATA\AUTOPREP.BAT" \
        -c "CALL E:\TESTDATA\AUTOSTD.BAT" \
        -c "CALL E:\TESTDATA\AUTOCLN.BAT" \
        2&> /dev/null 
      gtimeout --signal=SIGKILL 10s dosbox-x \
        -set "cpu cycles=407000" \
        -c "mount c ~/Documents/projects/UKMA/2025/KA/_TASM" \
        -c "mount d ." \
        -c "mount e ../_mserge/NMA-asm/" \
        -c "SET PATH=C:\\TASM" \
        -c "CALL E:\TESTDATA\AUTOPREP.BAT" \
        -c "CALL E:\TESTDATA\AUTOZADV.BAT" \
        -c "CALL E:\TESTDATA\AUTOCLN.BAT" \
        2&> /dev/null 
      gtimeout --signal=SIGKILL 10s dosbox-x \
        -set "cpu cycles=407000" \
        -c "mount c ~/Documents/projects/UKMA/2025/KA/_TASM" \
        -c "mount d ." \
        -c "mount e ../_mserge/NMA-asm/" \
        -c "SET PATH=C:\\TASM" \
        -c "CALL E:\TESTDATA\AUTOPREP.BAT" \
        -c "CALL E:\TESTDATA\AUTOCUST.BAT" \
        -c "CALL E:\TESTDATA\AUTOCLN.BAT" \
        2&> /dev/null 

      size=100000
      size_line="N/A"

      if [[ -f "NMA.COM" ]]; then
        size=$(stat -f%z NMA.COM)
        size_line="NMA.COM $size bytes"
      elif [[ -f "NMA.EXE" ]]; then
        size=$(stat -f%z NMA.EXE)
        size_line="NMA.EXE $size bytes"
      fi

      echo "$size_line" >> RESULT.TXT

      # Count individual test results
      orig_count=$(grep -c "ORIG.*PASSED" RESULT.TXT)
      std_count=$(grep -c "STD.*PASSED" RESULT.TXT)
      adv_count=$(grep -c "ADV.*PASSED" RESULT.TXT)
      big_count=$(grep -c "BIG.*PASSED" RESULT.TXT)
      cust_count=$(grep -c "CUST.*PASSED" RESULT.TXT)

      # Write to results.csv (parent directory)
      echo "${dir%/},$orig_count,$std_count,$adv_count,$big_count,$cust_count,$size" >> ../results.csv

      cat RESULT.TXT
    )
  fi
done

