#!/bin/sh
set -e

IMAGE="${1}"
TAG="${2}"
IMAGESPEC="${IMAGE}:${TAG}"
NODECOUNT=$(kubectl get node | awk '{ if ($2 == "Ready") print $1; }'  | wc -l)

JOBNAME=$(echo -n "pull-${IMAGE}-${TAG}-$(date +'%s')" | sed 's/\./-/g')

cat pulljob.yaml \
    | sed "s/{NODECOUNT}/${NODECOUNT}/" \
    | sed "s/{JOBNAME}/${JOBNAME}/" \
    | sed "s/{IMAGESPEC}/${IMAGESPEC}/" \
    | kubectl apply -f -

while true; do
    sleep 2 # Hack because .succeeded isn't populated instantly
    SUCCESSCOUNT=$(kubectl get job ${JOBNAME} -o jsonpath='{.status.succeeded}')
    if [ ${SUCCESSCOUNT} = ${NODECOUNT} ]; then
        echo "All nodes pulled successfully!"
        exit 0
    fi

    echo "Pulled ${SUCCESSCOUNT} of ${NODECOUNT} nodes"
done

kubectl delete job ${JOBNAME}
