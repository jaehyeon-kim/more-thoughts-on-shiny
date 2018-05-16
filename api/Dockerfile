FROM rockerextra/shiny-async-dev:3.4
MAINTAINER Jaehyeon Kim <dottami@gmail.com>

COPY ./* /home/rstudio/api/

RUN mkdir -p /etc/services.d/rserve \
    && echo '#!/usr/bin/with-contenv sh \n /usr/local/bin/R CMD Rserve --slave --RS-conf /home/rstudio/api/rserve.conf --RS-source /home/rstudio/api/rserve-src.R' > /etc/services.d/rserve/run

EXPOSE 8000

CMD ["/init"]
