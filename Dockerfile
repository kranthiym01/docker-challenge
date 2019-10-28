FROM tomcat:8.0-alpine

LABEL maintainer="kranthi.ym@gmail.com"

# Get latest updates and install git maven and jdk
RUN apk update && apk add git && apk add maven && apk add openjdk7

# Get the latest stable build from git
RUN git clone https://github.com/pebbleblog/pebble.git

# Change dir to pebble and run mvn package to create war file
RUN cd pebble && mvn package

# Create dir called content
RUN mkdir -p /usr/local/tomcat/content/

# Copy war file from target folder to content folder 
RUN cp pebble/target/pebble-*.war /usr/local/tomcat/content/pebble.war

# Add server.xml which gets the code base as content
ADD server.xml /usr/local/tomcat/conf

# Add tomcat-users.xml with admin/admin creds
ADD tomcat-users.xml /usr/local/tomcat/conf

EXPOSE 8080

CMD ["catalina.sh", "run"]
