FROM ubuntu:latest

RUN \
    echo '#!/bin/bash\n echo "value: ${TIMEOUT_VALUE}"\ntimeout -sHUP ${TIMEOUT_VALUE} bash /opt/fib.sh ${TIMEOUT_VALUE}' > entrypoint.sh && \
    chmod +x entrypoint.sh

COPY scripts/fib.sh /opt/fib.sh

ENTRYPOINT ["./entrypoint.sh"]