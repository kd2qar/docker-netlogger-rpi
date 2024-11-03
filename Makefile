#####
TAG=kd2qar/netlogger
NAME=netlogger

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth

CAPABILITIES =  --cap-add=SYS_ADMIN

ENV_VARS = \
        --env="USER_UID=$(shell id -u)" \
        --env="USER_GID=$(shell id -g)" \
        --env="DISPLAY" \
        --env="XAUTHORITY=${XAUTH}"
        #--env="SESSION_MANAGER"

VOLUMES = \
        --volume=${XSOCK}:${XSOCK} \
        --volume=${XAUTH}:${XAUTH} \
	--volume=/dev/tty1:/dev/tty1 \
	--volume=/dev/fb0:/dev/fb0 \
	--volume=/dev/gpiomem:/dev/gpiomem \
	--volume=/dev/input:/dev/input \
        --volume=/run/user/$(shell id -u)/pulse:/run/pulse 

DATE :=  $(shell date +%G%m%d%H%M)

WORKDIR="--workdir=/home/$(shell whoami)/"
HOMEDIR=--mount type=bind,source=/home/$(shell whoami)/,target=/home/$(shell whoami)/
USERFILES=--mount type=bind,source=/etc/passwd,target=/etc/passwd,readonly --mount type=bind,source=/etc/group,target=/etc/group,readonly
USER=--user $(shell id -u):$(shell id -g) 


LOG=--log-driver json-file --log-opt max-size=5m --log-opt max-file=1

all:
	docker  build --force-rm -t ${TAG}  . 

run: remove
	@echo "${WORKDIR}"
	@echo "${USER}"
	@echo "${HOMEDIR}"
	@echo "${USERFILES}"
	@echo "${ENV_VARS}"
	@echo "${CAPABILITIES}"
	@echo "${VOLUMES}"
	docker run -it --rm --privileged ${WORKDIR} ${USER} ${HOMEDIR} ${USERFILES} ${ENV_VARS} ${CAPABILITIES}  ${VOLUMES} --name ${NAME}_${DATE} --entrypoint /bin/bash ${TAG} -c /netlogger/nlbox

shell:
	docker run -it --rm --privileged ${WORKDIR}         ${HOMEDIR} ${USERFILES} ${ENV_VARS} ${CAPABILITIES}  ${VOLUMES} --name ${NAME}_shell --entrypoint /bin/bash ${TAG}




stop:
	@docker stop ${NAME} 2>/dev/null || true 2>/dev/null;

remove: stop
	@docker rm ${NAME} 2>/dev/null || true 2>/dev/null;
