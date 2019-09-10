Docker Toolbox installation for Android Device
==============================================
Docker Toolbox를 설치하고 Android 장비를 사용하기 위한 환경 구성을 설명합니다.
문서 작성 당시에는 Docker Toolbox 최신 버전이 v19.03.1이며, 이 버전에서 사용하기 위한 방법을 설명합니다.
Docker Toolbox v19.03.1 버전에서는 Virtualbox와 Windows 10 Host 사이에 Shared folder와 관련된 버그가 있습니다.
해당 버그를 해결하는 방법을 함께 설명합니다.

Installation
------------ 
1. Install 'Docker Toolbox for Windows' - 참조 : [Docker Toolbox for Windows](https://docs.docker.com/toolbox/toolbox_install_windows/)
2. Run 'Docker Quickstart Terminal'
3. 'Docker Quickstart Terminal' 실행이 완료되면 동작중인 Virtualbox에 실행된 docker-machine을 제거하고 새로운 boot2docker 이미지를 사용하여 새로우누 docker-machine을 생성합니다.
```
$ docker-machine.exe stop
$ docker-machine.exe rm default
$ docker-machine.exe create --virtualbox-boot2docker-url https://github.com/boot2docker/boot2docker/releases/download/v18.09.8/boot2docker.iso default
$ docker-machine.exe stop
```
4. Virtualbox를 실행하여 docker-machine이 Android장비를 사용할 수 있게 설정합니다.
![Machine Setting](/img/virtualbox-machine-setting.png)
![Machine Setting - USB](/img/virtualbox-usb-setting.png)
![Machine Setting - USB - Device Select](/img/virtualbox-usb-setting-device-select.png)
![Machine Setting - USB - OK](/img/virtualbox-usb-setting-final.png)

