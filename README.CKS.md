CKS Preparation - Sept, 2022
Members (4): 정인환/정종인/정진호/임예슬

Security Best Practices

> Security Principles
  - Security combines many different things
  - Environment change, security cannot stay in a certain state
  - Attackers have advantage
    . They decide time
    . They pick what to attack, like weakest link
  - Defense in Depth
  - Least Privilege
  - Limiting the Attack Surface
  - Layered defence and Redundancy
    . Redundancy is good... in security
        . DRY "Don't repeat yourself"? (X)
    . layers
        . Least Privileges
        . Redurdent Security layer
        . Reduce Attack Surface

> K8s Security Categoires
    . Appliction Security
        - Use Secrets / no hardcoded credentials
        - RBAC
        - Container Sandboxing
            . Attack Surface
            . Run as user
            . Readonly filesystem
        - Vulnerability Security
        . mTLS/ServiceMeshes
    . K8s Cluster Security
        - K8s components one running secure and up-to-date
            . api server
            . kubelet
            . etcd
        - Restrict (external) access
        - User Atuhentication -> Authorization
        - AdmissionController
            . NodeRestriction
            . Custom Policies(OPA)
        - Enable Audit Logging
        - Security Benchmarking
            ex. Encrypt etcd            
    . HOST Operating System Security
        - Kubernetes Nodes should only do one thing: K8s
        - Reduce Surface Attack
            . Remove unnecessary applicaton
            . Keep up-to-date
        - Runtime Security tools
        -. Find and identify malicious processes
        - Restrict IAM/SSH acccess
        
> K8s Best Practices
  - https://www.youtube.com/watch?v=wqsUfvRyYpw
