#!/bin/sh
set -e

IMAGE="${1}"
TAG="${2}"
shift 2
NODENAMES=$(kubectl get node $@ | awk '{ if ($2 == "Ready") print $1; }')
NODECOUNT=$(echo "$NODENAMES" | wc -l)
NODENAMESARRAY="["
for name in $NODENAMES; do
  NODENAMESARRAY="${NODENAMESARRAY}${sep}\"${name}\""
  sep=", "
done
NODENAMESARRAY="${NODENAMESARRAY}]"

IMAGESHORTNAME=$(echo -n ${IMAGE} | cut -d'/' -f3)
JOBNAME=$(echo -n "pull-${IMAGESHORTNAME}-${TAG}-$(date +'%s')" | sed 's/\./-/g')

echo "Pulling ${IMAGE}:${TAG} on ${NODECOUNT} nodes" 

cat pulljob.yaml \
    | sed "s/{NODECOUNT}/${NODECOUNT}/" \
    | sed "s/{JOBNAME}/${JOBNAME}/" \
    | sed "s_{IMAGE}_${IMAGE}_" \
    | sed "s_{TAG}_${TAG}_" \
    | sed "s_{NODENAMES}_${NODENAMESARRAY}_" \
    | kubectl apply -f -

while true; do
    sleep 2 # Hack because .succeeded isn't populated instantly
    SUCCESSCOUNT=$(kubectl get job ${JOBNAME} -o jsonpath='{.status.succeeded}')
    if [ ${SUCCESSCOUNT} -eq ${NODECOUNT} ]; then
        echo "All nodes pulled successfully!"
        kubectl delete job ${JOBNAME}
        exit 0
    fi

    echo "Pulled ${SUCCESSCOUNT} of ${NODECOUNT} nodes"
done
