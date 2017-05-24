FROM openjdk:8-jdk-alpine

RUN   apk update \                                                                                                                                                                                                                        
 &&   apk add ca-certificates wget \                                                                                                                                                                                                      
 &&   update-ca-certificates  

ENV PAYARA_PKG https://s3-eu-west-1.amazonaws.com/payara.fish/Payara+Downloads/Payara+4.1.2.172/payara-micro-4.1.2.172.jar
ENV PAYARA_VERSION 172
ENV PKG_FILE_NAME payara-micro.jar
ENV PAYARA_PATH /opt/payara

RUN \
  mkdir -p $PAYARA_PATH && \
  wget --quiet -O $PAYARA_PATH/$PKG_FILE_NAME $PAYARA_PKG

RUN \
 mkdir -p $PAYARA_PATH/deployments && \
 adduser -D -h $PAYARA_PATH payara && echo payara:payara | chpasswd && \
 chown -R payara:payara /opt

ENV DEPLOY_DIR $PAYARA_PATH/deployments
ENV AUTODEPLOY_DIR $PAYARA_PATH/deployments
ENV PAYARA_MICRO_JAR=$PAYARA_PATH/$PKG_FILE_NAME

# Default payara ports to expose
EXPOSE 4848 8009 8080 8181

USER payara
WORKDIR $PAYARA_PATH

ENTRYPOINT ["java", "-jar", "/opt/payara/payara-micro.jar"]
CMD ["--deploymentDir", "/opt/payara/deployments"]