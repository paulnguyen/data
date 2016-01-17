     ,-----.,--.                  ,--. ,---.   ,--.,------.  ,------.
    '  .--./|  | ,---. ,--.,--. ,-|  || o   \  |  ||  .-.  \ |  .---'
    |  |    |  || .-. ||  ||  |' .-. |`..'  |  |  ||  |  \  :|  `--, 
    '  '--'\|  |' '-' ''  ''  '\ `-' | .'  /   |  ||  '--'  /|  `---.
     `-----'`--' `---'  `----'  `---'  `--'    `--'`-------' `------'
    ----------------------------------------------------------------- 


## Support & Documentation

Visit http://docs.c9.io for support, or to learn more about using Cloud9 IDE. 
To watch some training videos, visit http://www.youtube.com/user/c9ide

## Cloud9 Database Setup

    https://docs.c9.io/docs/setup-a-database
    https://docs.c9.io/docs/setting-up-cassandra
    https://docs.c9.io/docs/setting-up-couchdb
    https://docs.c9.io/docs/setting-up-mongodb
    https://docs.c9.io/docs/setting-up-mysql
    https://docs.c9.io/docs/setting-up-postgresql
    https://docs.c9.io/docs/setting-up-redis
    https://docs.c9.io/docs/setting-up-sqlite3

## Install AspectJ Compiler & Tools

    $ pwd
    /home/ubuntu
    $ ls
    lib/  workspace/
    $ unzip workspace/aspectj/aspectj1.8.zip 
    creating: aspectj1.8/
    creating: aspectj1.8/bin/
    inflating: aspectj1.8/bin/aj 
    ...
    
## Setup AspectJ and Java Home

    $ vi /home/ubuntu/.bashrc
    
    # SET UP ASPECTJ and JAVA
    export CLASSPATH=/home/ubuntu/aspectj1.8/lib/aspectjrt.jar:.
    export PATH=$PATH:/home/ubuntu/aspectj1.8/bin:.
    export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
    export ASPECTJ_HOME=/home/ubuntu/aspectj1.8
    export ASPECTJ_RT=/home/ubuntu/aspectj1.8/lib/aspectjrt.jar
