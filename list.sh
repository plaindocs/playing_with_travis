#!/bin/bash
lang=$1

help() {
    cat<<\EOF
Script to list the language runtimes that can be installed from the Travis CI
S3 buckets.
Usage:
    list-language-archive php
Or:
    for lan in perl php python rubies; do list-language-archive $lan; done
EOF
    exit
}

if [[ $lang = help || $lang = "--help" || -z "$lang" || "$lang" = "-h" ]];
then help
elif [[ "$lang" = ruby || "$lang" = rubies ]]
then url=s3://travis-rubies
else url="s3://travis-$lang-archives"
fi

filter() {
    gawk -F/ '
        BEGIN{
            PROCINFO["sorted_in"] = "@ind_num_asc"
        }
        /binaries/&&/bz2$/{
            bin=gensub(/\.tar\.bz2$/, "", 1, $NF)
            image = $(NF-3)"-"$(NF-2)
            archive[bin][image] = image
            images[image] = image
            
        }
        END {
            for (bin in archive) {
                s=""
                for (image in images)
                    s = sprintf("%s %12s", s, archive[bin][image])
                printf("%-30s %s\n", bin, s)
            }
        }
    '
}

aws s3 ls --recursive "$url" | filter

# vim: syntax=sh
