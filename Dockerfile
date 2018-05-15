FROM rockerextra/shiny-async-dev:3.4
MAINTAINER Jaehyeon Kim <dottami@gmail.com>

RUN mkdir -p /etc/services.d/javascript \
    && echo '#!/usr/bin/with-contenv sh \n python /home/rstudio/javascript/serve.py -p 7000 -d /home/rstudio/javascript' > /etc/services.d/javascript/run \
    && mkdir -p /etc/services.d/rserve \
    && echo '#!/usr/bin/with-contenv sh \n /usr/local/bin/R CMD Rserve --slave --RS-conf /home/rstudio/api/rserve.conf --RS-source /home/rstudio/api/rserve-src.R' > /etc/services.d/rserve/run

