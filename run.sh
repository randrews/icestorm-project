docker run \
       -it \
       --mount type=bind,source=$(realpath $(dirname $0)),destination=/project \
       -w /project \
       --privileged \
       icestorm
