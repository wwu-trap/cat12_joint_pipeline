FROM ubuntu:22.04 as intermediate

LABEL org.opencontainers.image.authors="University of Muenster, Institute for Translational Psychiatry"
LABEL org.opencontainers.image.source="https://github.com/wwu-trap/cat12_joint_pipeline"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
     unzip xorg wget \
 && apt-get clean \
 && rm -rf \
     /tmp/hsperfdata* \
     /var/*/apt/*/partial \
     /var/lib/apt/lists/* \
     /var/log/apt/term*

# Install MATLAB MCR in /opt/mcr/
ENV MATLAB_VERSION R2019a
ENV MCR_VERSION v96
ENV MCR_UPDATE 9
RUN mkdir /opt/mcr_install \
 && mkdir /opt/mcr \
 && wget --progress=bar:force -P /opt/mcr_install https://ssd.mathworks.com/supportfiles/downloads/${MATLAB_VERSION}/Release/${MCR_UPDATE}/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_${MATLAB_VERSION}_Update_${MCR_UPDATE}_glnxa64.zip \
 && unzip -q /opt/mcr_install/MATLAB_Runtime_${MATLAB_VERSION}_Update_${MCR_UPDATE}_glnxa64.zip -d /opt/mcr_install \
 && /opt/mcr_install/install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent \
 && rm -rf /opt/mcr_install /tmp/*

# Install SPM with CJPv8 Standalone in /opt/${CJP_REVISION}/
ENV SPM_VERSION 12
ENV CJP_REVISION cjp_v0008-spm12_v7771-cat12_r1720
ENV LD_LIBRARY_PATH /opt/mcr/${MCR_VERSION}/runtime/glnxa64:/opt/mcr/${MCR_VERSION}/bin/glnxa64:/opt/mcr/${MCR_VERSION}/sys/os/glnxa64:/opt/mcr/${MCR_VERSION}/sys/opengl/lib/glnxa64:/opt/mcr/${MCR_VERSION}/extern/bin/glnxa64
ENV MCR_INHIBIT_CTF_LOCK 1
ENV SPM_HTML_BROWSER 0
# Running SPM once with "function exit" tests the succesfull installation *and*
# extracts the ctf archive which is necessary if singularity is going to be
# used later on, because singularity containers are read-only.
# Also, set +x on the entrypoint for non-root container invocations
RUN wget --no-check-certificate --progress=bar:force -P /opt https://github.com/wwu-trap/cat12_joint_pipeline/releases/download/cjp8/${CJP_REVISION}.tar.gz \
 && tar xf /opt/${CJP_REVISION}.tar.gz -C /opt \
 && rm -f /opt/${CJP_REVISION}.tar.gz \
 && chmod +x /opt/${CJP_REVISION}/spm${SPM_VERSION} \
 && /opt/${CJP_REVISION}/spm${SPM_VERSION} function exit

RUN chmod +r -R /opt/${CJP_REVISION}/ \
 && find /opt/${CJP_REVISION}/spm${SPM_VERSION} \( -name "*mex*" -and -not -iname "*.auth" \) -exec chmod +rx {} \;

RUN cd /opt/ && tar cfz ${CJP_REVISION}.tar.gz ${CJP_REVISION}


FROM ubuntu:22.04

LABEL org.opencontainers.image.authors="University of Muenster, Institute for Translational Psychiatry"
LABEL org.opencontainers.image.source="https://github.com/wwu-trap/cat12_joint_pipeline"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
     unzip xorg wget uuid-runtime \
 && apt-get clean \
 && rm -rf \
     /tmp/hsperfdata* \
     /var/*/apt/*/partial \
     /var/lib/apt/lists/* \
     /var/log/apt/term*

ENV CJP_REVISION cjp_v0008-spm12_v7771-cat12_r1720

COPY --from=intermediate /opt/${CJP_REVISION}.tar.gz /opt/${CJP_REVISION}.tar.gz
RUN cd /opt/ && tar xf /opt/${CJP_REVISION}.tar.gz && rm -f /opt/${CJP_REVISION}.tar.gz

ENV MATLAB_VERSION R2019a
ENV MCR_VERSION v96
ENV MCR_UPDATE 9
ENV SPM_VERSION 12
ENV LD_LIBRARY_PATH /opt/mcr/${MCR_VERSION}/runtime/glnxa64:/opt/mcr/${MCR_VERSION}/bin/glnxa64:/opt/mcr/${MCR_VERSION}/sys/os/glnxa64:/opt/mcr/${MCR_VERSION}/sys/opengl/lib/glnxa64:/opt/mcr/${MCR_VERSION}/extern/bin/glnxa64
ENV MCR_INHIBIT_CTF_LOCK 1
ENV SPM_HTML_BROWSER 0
ENV BATCH_TEMPLATE_PATH /opt/cjp8-batch-template.mat


RUN mkdir /scripts/
COPY ./batch/cat12_complete_joint_pipeline.mat ${BATCH_TEMPLATE_PATH}
COPY ./docker/* /scripts/
RUN chmod +r -R /scripts/ && chmod +x /scripts/*.sh

# Configure entry point
ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["--help"]
