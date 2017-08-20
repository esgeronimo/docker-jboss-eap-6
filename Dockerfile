# Image for JBoss EAP 6
# Please don't use this for PRODUCTION deployment

FROM jboss/base-jdk:7

# installer and resources directory
ENV INST_DIR=/usr/src/jboss-eap-6-installer
# server directory
ENV SERVER_DIR=/opt/jboss-eap-6.4

# management console credentials
ENV MGMT_CONSOLE_USER_NAME=jbossadmin
ENV MGMT_CONSOLE_PWD=S3cur!ty

# required to allow creation of dirs and files
USER root

# install and setup JBoss EAP
COPY . ${INST_DIR}
WORKDIR ${INST_DIR}
RUN unzip ./jboss-eap-6.4.0.zip -d /opt \
    && rm -rf ${INST_DIR} \
    && cd ${SERVER_DIR} \
    && bin/add-user.sh ${MGMT_CONSOLE_USER_NAME} ${MGMT_CONSOLE_PWD} --silent

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

EXPOSE 8080
EXPOSE 9990

WORKDIR ${SERVER_DIR}
CMD ["bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]