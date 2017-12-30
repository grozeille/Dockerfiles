FROM cloudflare/opentsdb

# install hbase client
ARG HBASE_VERSION=1.2.6
RUN url="http://www.apache.org/dyn/closer.lua?filename=hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz&action=download"; \
  url_archive="http://archive.apache.org/dist/hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz"; \
  wget -t 10 --max-redirect 1 --retry-connrefused -O "hbase-$HBASE_VERSION-bin.tar.gz" "$url" || \
  wget -t 10 --max-redirect 1 --retry-connrefused -O "hbase-$HBASE_VERSION-bin.tar.gz" "$url_archive" && \
  mkdir "hbase-$HBASE_VERSION" && \
  tar zxf "hbase-$HBASE_VERSION-bin.tar.gz" -C "hbase-$HBASE_VERSION" --strip 1 && \
  test -d "hbase-$HBASE_VERSION" && \
  ln -sv "hbase-$HBASE_VERSION" hbase && \
  rm -fv "hbase-$HBASE_VERSION-bin.tar.gz" && \
  { rm -rf hbase/{docs,src}; : ; }

COPY hbase-site.xml /hbase/conf/

RUN apt-get install --no-install-recommends -y curl
COPY run2.sh /
RUN chmod +x /run2.sh

ENTRYPOINT "/run2.sh"