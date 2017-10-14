#!/usr/bin/env bash


mkdir -p $HOME/.local/bin/
ngless-install.py --mode=user
export PATH=$HOME/.local/bin:$PATH

FAILURES=0
for script in cwl/*.cwl; do
    # --leave-outputs - to leave outputs on the tmpdir created by cwl-runner (we don't need them)
    # --preserve-environment - to ensure ngless is found
    # --debug - in case something fails we have extra info
    cwl-runner --debug --rm-tmpdir --leave-outputs \
        --preserve-environment PATH \
        "$script" "test-data/$(basename "${script%.*}".yml)" || { echo "Running $script failed"; let "FAILURES+=1"; }
done

if [ "$FAILURES" != "0" ]; then
    echo "Some CWL tests failed"
    exit 1
fi
