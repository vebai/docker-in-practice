DOCKER VALIDATION SUITE — QUICK START

1. Extract the ZIP into the root of:
   ~/Downloads/book-validation-20261104/docker-in-practice/
   You should then have: docker-in-practice/validation/run-all.sh

2. On your Mac:
   cd ~/Downloads/book-validation-20261104/docker-in-practice
   chmod +x validation/*.sh
   ./validation/run-all.sh --status

3. Begin from Chapter 5, because 3–4 were already validated manually:
   ./validation/run-all.sh --from 05

4. A failed checkpoint stops the suite. Inspect its .log/.fail and Docker logs.
   Then clean up just the failed chapter and rerun that chapter or resume:
   ./validation/ch05.sh cleanup
   ./validation/run-all.sh --from 05

See validation/README.md for detailed behaviour, security boundaries and limits.
