FROM adoptopenjdk/openjdk15:alpine-slim
ARG Asia/Shanghai
WORKDIR /mirai
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache ca-certificates \
    && apk add --no-cache curl bash busybox tree tzdata expect git \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apk del tzdata \
    && wget https://download.fastgit.org/iTXTech/mirai-console-loader/releases/download/v1.0.5/mcl-1.0.5.zip -P /root \
    && unzip /root/mcl-1.0.5.zip -d /mirai \
    && rm /root/mcl-1.0.5.zip \
    && chmod +x /mirai/mcl \
    && echo -e '#!/usr/bin/expect\ncd /mirai\nspawn java -jar mcl.jar\nexpect "mirai-console started successfully."\nexp_send "stop\\n"\ninteract' > /root/init.sh \
    && chmod +x /root/init.sh \
    && /root/init.sh \
    && rm /root/init.sh \
    && mkdir /mirai/plugins \
    && java -jar /mirai/mcl.jar --update-package net.mamoe:chat-command --channel stable --type plugin \
    && java -jar /mirai/mcl.jar --update-package net.mamoe:mirai-api-http --channel stable --type plugin
CMD ["java", "-jar", "mcl.jar"]
