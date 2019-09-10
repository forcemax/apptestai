Apptest.ai Console Test Tool
=============
Apptest.ai Console Test Tool은 간단한 방법으로 자신의 PC에서 자신의 Android 장비를 사용하여 Apptest.ai Test를 수행할 수 있는 도구입니다.


Installation
------------
1. Install [Docker](https://www.docker.com/)
2. Pull the Docker image : ```docker pull apptestai/apptestai-docker```
3. Download runtest.sh script : ```wget https://raw.githubusercontent.com/forcemax/apptestai/master/runtest.sh```

Windows/Mac은 자신의 Android 장비를 사용하기 위하여 [Docker Desktop](https://www.docker.com/products/docker-desktop)이 아닌 [Docker Toolbox](https://docs.docker.com/toolbox/)를 사용해야하며, 이를 위한 문서는 다음에서 확인할 수 있습니다.<br/>
[Install Dcoker Toolbox for Android Device](DockerToolbox.md)

Usage
-----
**Pre-Requisites:** 
1. Ubuntu 18.04 LTS (https://ubuntu.com)
2. Docker 19.03 (latest) (https://docs.docker.com/install/linux/docker-ce/ubuntu/)
3. Android SDK - adb 명령 필요
4. Android 5.0 lollipop 이상의 버전을 사용하는 장비
5. Test 수행할 APK 파일 - application.apk

**장비 UDID 확인**
```
$ adb devices
* daemon not running; starting now at tcp:5037
* daemon started successfully
List of devices attached
ce0817182be9566f0b      device
```

**Apptest.ai Test 실행**
```
$ chmod u+x runtest.sh
$ ./runtest.sh -d ce0817182be9566f0b -f application.apk
```


Test Result
-----------
테스를 수행하고나면 현재 디렉토리의 아래에 output 디렉토리가 생성되며 다음과 같은 구조로 되어있다.

    .
    └── output
        ├── logs                # logcat log, apptestai script log, etc...
        ├── screenshots         # screenshots, xml, action metadata
        ├── TEST-result.html
        ├── TEST-result.json
        ├── application.apk
        ├── console.log
        └── credentials.csv

