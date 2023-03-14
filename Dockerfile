FROM adoptopenjdk/openjdk16:alpine-slim
ARG Asia/Shanghai
WORKDIR /mirai
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache ca-certificates curl bash busybox tree tzdata expect \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && wget https://ghproxy.com/https://github.com/iTXTech/mirai-console-loader/releases/download/v2.1.2/mcl-2.1.2.zip -P /root \
    && unzip /root/mcl-2.1.2.zip -d /mirai \
    && rm /root/init.sh /root/mcl-2.1.2.zip \
    && echo -e '#!/usr/bin/expect\ncd /mirai\nspawn java -jar mcl.jar\nexpect "mirai-console started successfully."\nexp_send "stop\\n"\ninteract' > /root/init.sh \
    && chmod +x /root/init.sh \
    && java -jar /mirai/mcl.jar --update-package net.mamoe:mirai-core-all --channel libs --type plugin \
    && java -jar /mirai/mcl.jar --update-package net.mamoe:chat-command --channel stable --type plugin \
    && java -jar /mirai/mcl.jar --update-package net.mamoe:mirai-api-http --channel stable --type plugin \
    && java -jar /mirai/mcl.jar --update-package org.itxtech:mcl-addon --channel stable --type plugin \
    && /root/init.sh \
    && apk del tzdata expect
CMD ["java", "-jar", "mcl.jar"]
