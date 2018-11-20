#       Copyright 2017 IBM Corp All Rights Reserved

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#       http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

# FROM openliberty/open-liberty:microProfile1
FROM websphere-liberty:microProfile
# This is what JAG said to use to build locally
#FROM websphere-liberty:18.0.0.3-webProfile7

COPY /target/liberty/wlp/usr/servers/defaultServer /config/

## Copy in portfolio prereqs:
COPY lib/db2jcc4.jar /config/db2jcc4.jar
COPY lib/wmq.jmsra.rar /config/wmq.jmsra.rar

# Changes recommended from Microclimate troubleshooting
USER root
RUN chmod g+w /config/apps
USER 1001

RUN installUtility install --acceptLicense defaultServer
# Upgrade to production license if URL to JAR provided
ARG LICENSE_JAR_URL
RUN \
  if [ $LICENSE_JAR_URL ]; then \
    wget $LICENSE_JAR_URL -O /tmp/license.jar \
    && java -jar /tmp/license.jar -acceptLicense /opt/ibm \
    && rm /tmp/license.jar; \
  fi
