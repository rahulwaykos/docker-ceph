

#kubectl patch storageclass rook-ceph-block -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'


kubectl exec -n rook-ceph -it $(kubectl get -n rook-ceph pod -l "app=rook-ceph-tools" -o jsonpath='{.items[0].metadata.name}') bash
