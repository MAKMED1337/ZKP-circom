#!/bin/bash
# Force mocha to rerun one test in parallel, to check on random samples

base_path="test/parallel"

num_copies=5

for ((i=1; i<=num_copies; i++)); do
    new_filename="main-${i}.test.ts"

    cp "${base_path}/main.test.ts" "${base_path}/${new_filename}"
done

echo "Operation completed successfully."

