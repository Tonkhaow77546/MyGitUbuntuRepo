#!/bin/bash

# Create a temporary file to store successful results
temp_file=$(mktemp)

# Add the CSV header to the temporary file
echo "Server ID,Sponsor,Server Name,Timestamp,Distance,Ping,Download,Upload,Share,IP Address" > "$temp_file"


# Get the list of servers and extract server IDs
server_ids=$(speedtest-cli --list | grep -oE '^[0-9]+' | tr '\n' ' ')

# Loop through each server ID and run a speed test
for server_id in $server_ids; do
  echo "Testing server: $server_id"
  if speedtest-cli --server "$server_id" --csv --csv-delimiter ',' >> "$temp_file"; then  # Append successful results to the temporary file
    echo "Server: '$server_id' SUCCEEDED"
  else
    echo "Server: '$server_id' FAILED"
  fi
  echo "--------------------"
done

# Move the temporary file to a permanent location with a meaningful name
mv "$temp_file" speedtest_results.csv

echo "Testing complete. Results saved to speedtest_results.csv"

# Clean up (optional, remove if you want to keep the temporary file)
# rm "$temp_file"
