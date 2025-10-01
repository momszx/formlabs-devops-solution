# Tech Choices

## Why Alpine instead of python:3.12?
- Half the size (77MB vs 177MB)
- Fewer vulnerabilities to patch
- Still works fine with Python virtual envs

## Why multi-stage Docker build?
- Don't need pip and dev tools in production
- Smaller final image
- Standard practice for production containers

## Why non-root user?
- Container security 101
- Trivy scanner recommends UID > 10000
- If container gets pwned, attacker can't do much

## Why Helm instead of plain YAML?
- Can template values (like resource limits)
- Easier to deploy to different environments
- Standard way to package Kubernetes apps

## Why all the security contexts?
- ReadOnlyRootFilesystem: App can't write to filesystem
- Drop capabilities: Container can't do privileged operations
- Seccomp: Limits what syscalls the process can make
- Basically making it harder for bad things to happen

## Why GitHub Actions?
- Already using GitHub
- Don't need to run Jenkins server
- Built-in security scanning integration
- Simple YAML config

## Why Trivy scanning?
- Finds known vulnerabilities in dependencies
- Runs automatically on every build
- Free and works well

## What I didn't use and why:
- **Jenkins**: More complex setup than needed
- **Root user**: Security risk
- **Debian base**: Bigger and more attack surface

## What could be added for production:
- **Network policies**: Restrict pod-to-pod communication (not needed for single pod)
- **Service mesh** (Istio/Linkerd): mTLS between services (overkill for hello world)
- **Zero trust networking** (Calico + WireGuard): Encrypt all traffic (enterprise feature)
- **Pod Security Standards**: Enforce security policies cluster-wide
- **OPA Gatekeeper**: Policy enforcement beyond basic security contexts

For this simple app these would be over-engineering, but worth considering in multi-service environments.