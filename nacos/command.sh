docker run -d \                      
###
 # @Author: KrabWW wei17306927526@gmail.com
 # @Date: 2026-01-05 14:47:29
 # @LastEditors: KrabWW wei17306927526@gmail.com
 # @LastEditTime: 2026-01-05 14:47:31
 # @FilePath: /docker_compose_normal/nacos/command.sh
 # @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
### 
--name nacos-standalone \
-e MODE=standalone \
-e NACOS_AUTH_ENABLE=false \
-p 8848:8848 \
-p 9848:9848 \
-p 9849:9849 \
nacos/nacos-server:v2.4.0