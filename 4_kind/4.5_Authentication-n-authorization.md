###########################################################################################
#  1. Let's create a simple scenario
###########################################################################################

# Create namespaces red and blue
k create ns red
k create ns blue

# User Jane can only get secretes in namespace red
# User Jane can only get and list secrets in namespace blue
k -n red create role secret-manager --verb=get --resource=secrets
k -n red create rolebinding secret-manager --role=secret-manager --user=jane
k -n blue create role secret-manager --verb=get --verb=list --resource=secrets
k -n blue create rolebinding secret-manager --role=secret-manager --user=jane

# Test it using auth can-i
# check permissions
k -n red auth can-i -h
k -n red auth can-i create pods --as jane # no
k -n red auth can-i get secrets --as jane # yes
k -n red auth can-i list secrets --as jane # no

k -n blue auth can-i list secrets --as jane # yes
k -n blue auth can-i get secrets --as jane # yes

k -n default auth can-i get secrets --as jane #no


###########################################################################################
#  2. Let's create another scenario
###########################################################################################

# Create a ClusterRole deploy-deleter which allows to delete deployments
k create clusterrole deploy-deleter --verb=delete --resource=deployment

# User jane can delete deployments in all namespaces
k create clusterrolebinding deploy-deleter --clusterrole=deploy-deleter --user=jane

# User jim can delete deployments only in namespace red
k -n red create rolebinding deploy-deleter --clusterrole=deploy-deleter --user=jim


# Test it using auth can-i
# test jane
k auth can-i delete deploy --as jane # yes
k auth can-i delete deploy --as jane -n red # yes
k auth can-i delete deploy --as jane -n blue # yes
k auth can-i delete deploy --as jane -A # yes
k auth can-i create deploy --as jane --all-namespaces # no


# test jim
k auth can-i delete deploy --as jim # no
k auth can-i delete deploy --as jim -A # no
k auth can-i delete deploy --as jim -n red # yes
k auth can-i delete deploy --as jim -n blue # no


###########################################################################################
#  3. Accounts  - ServiceAccount & "normal user"
# Create KEY -> Create CSR -> Request CSR to K8s API -> Download CRT from K8s API -> Use CRT+KEY
###########################################################################################

# there is a ServiceAccount resource mananged by the k8s api
# it is assumed that a cluster-independent service manages normal users

# normal user"
# there is no k8s User resource.  A user is someone with a cert and key

# Users and Certificates
# -. client cert
#   . certificate signed by the cluster's certificate authority(CA)
#   . username under common name /CN=jane

# -. Users and Certificates - Leak + Invalidation
#   . There is o way to invalidate a certificate
#   . If a certificate has been leaked
#       > Remove all access via RBAC
#       > Username cannot be used until cert expired
#       > Create new CA ad re-issue all certs

# Create a certificate+key and authenticate as user jane
# Create CSR
# Sign CSR using kubernetes API
# Use cert+key to connect to k8s API

openssl genrsa -out jane.key 2048
openssl req -new -key jane.key -out jane.csr # only set Common Name = jane



# create CertificateSigningRequest with base64 jane.csr
https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests
cat jane.csr | base64 -w 0


# add new KUBECONFIG
k config set-credentials jane --client-key=jane.key --client-certificate=jane.crt
k config set-context jane --cluster=kubernetes --user=jane
k config view
k config get-contexts
k config use-context jane



###########################################################################################
#  4. 
###########################################################################################

# from inside a Pod we can do:
cat /run/secrets/kubernetes.io/serviceaccount/token

curl https://kubernetes.default -k -H "Authorization: Bearer SA_TOKEN"


###########################################################################################
#  5. 
###########################################################################################

# from inside a Pod we can do:
cat /run/secrets/kubernetes.io/serviceaccount/token

curl https://kubernetes.default -k -H "Authorization: Bearer SA_TOKEN"

https://kubernetes.io/docs/tasks/run-application/access-api-from-pod


# Bound Service Account Tokens
https://github.com/kubernetes/enhancements/blob/master/keps/sig-auth/1205-bound-service-account-tokens/README.md



###########################################################################################
#  6. 
###########################################################################################

https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account



###########################################################################################
#  7. 
###########################################################################################

https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin

https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account


###########################################################################################
#  8. 
###########################################################################################

# inspect apiserver cert
cd /etc/kubernetes/pki
openssl x509 -in apiserver.crt -text


###########################################################################################
#  9. 
###########################################################################################

https://kubernetes.io/docs/concepts/security/controlling-access
