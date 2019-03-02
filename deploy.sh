#!/usr/bin/env bash
#编译+部署jenkins站点

#需要配置如下参数
# 项目路径, 在Execute Shell中配置项目路径, pwd 就可以获得该项目路径
# export PROJ_PATH=这个jenkins任务在部署机器上的路径

# maven编译git下的源码
cd $PROJ_PATH
mvn -DskipTests clean install

# 删除原有的测试代码
rm -rf /data/jenkinstest/*.jar
rm -rf /data/jenkinstest/*.sh

# 替换代码
cd /data/jenkinstest/
cp $PROJ_PATH/target/jenkinstest-0.0.1-SNAPSHOT-1.0.tar.gz .
tar -zxvf jenkinstest-0.0.1-SNAPSHOT-1.0.tar.gz
rm -rf jenkinstest-0.0.1-SNAPSHOT-1.0.tar.gz

# 重启服务
bin/server.sh restart
