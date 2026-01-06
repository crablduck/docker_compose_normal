docker run -d \                      
--name nacos-standalone \
-e MODE=standalone \
-e NACOS_AUTH_ENABLE=false \
-p 8848:8848 \
-p 9848:9848 \
-p 9849:9849 \
nacos/nacos-server:v2.4.0