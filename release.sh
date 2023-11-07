#!/usr/bin/env bash

# get the tags from the compiled fw repo:
tags=$(git tag)
tags_array=()
for tag in $tags; do
  if [[ $tag == v1.* ]]; then
    tags_array+=("$tag")
  fi
done

# start the loop of tags...
for tag in "${tags_array[@]}"; do
  echo "Building and committing $tag"
  sleep 5

  # checkout the source tag
  git checkout $tag

  # delete the compiled/prod binary FW repo tag
  cd bin
  git tag -d $tag

  # go back to source with checked-out tag and build
  cd ../
  bash ./build_fw.sh

  # go back ro compiled/prod binary FW repo and tage it
  cd bin
  git tag $tag

  # back to source to start over
  cd ../
done

