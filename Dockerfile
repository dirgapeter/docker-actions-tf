FROM hashicorp/terraform:0.12.13

RUN apk --no-cache add --update bash curl docker nodejs npm openssl

# Install Kubectl
ARG KUBECTL_VERSION=v1.14.7
RUN curl -L -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl && \
  chmod +x /usr/bin/kubectl

RUN curl -L -o /usr/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator && \
  chmod +x /usr/bin/aws-iam-authenticator

# Install AWS CLI
ARG AWSCLI_VERSION=1.16.260
RUN apk --no-cache add python py-pip py-setuptools ca-certificates curl groff less \
  && pip --no-cache-dir install awscli==$AWSCLI_VERSION --upgrade \
  && apk --purge -v del py-pip \
  && rm -rf /var/cache/apk/*

# https://issues.jenkins-ci.org/browse/JENKINS-51307
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
