ASAR_URL = https://github.com/RPGHacker/asar/archive/refs/tags/v1.91.tar.gz

ASAR_DIR = tools/asar
TMP_DIR = tmp
SRC_DIR = source
OUT_DIR = out
NAME = ROM

CMAKE = cmake
CMAKE_ASAR_GENERATOR := "Ninja"

current_dir = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

ifeq ($(OS),Windows_NT)
	ASAR_EXECUTABLE := asar.exe
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		ASAR_EXECUTABLE := asar
	endif
	ifeq ($(UNAME_S),Darwin)
		$(error You seem to be running MacOS. Please contact me on Discord (@alexmush) and tell me the contents of $(ASAR_DIR)/asar so that i can make this available to compile on MacOS)
	endif	
endif

SYM=none

debug: SYM=wla --symbols-path="${OUT_DIR}/${NAME}.sym"

build: asar ${NAME}
debug: asar ${NAME}
force_update_asar: rm_asar asar

asar: ${ASAR_DIR}/asar/bin/${ASAR_EXECUTABLE}
${NAME}: ${OUT_DIR}/${NAME}.sfc
    
rm_asar: ${ASAR_DIR}
	rm -rf ${ASAR_DIR}

${OUT_DIR}/${NAME}.sfc: asar ${OUT_DIR} ${SRC_DIR}/*
	${ASAR_DIR}/asar/bin/${ASAR_EXECUTABLE} -v --symbols=${SYM} -I"${OUT_DIR}" -I"${TMP_DIR}" -I"${SRC_DIR}" --fix-checksum=on "${SRC_DIR}/main.asm" "${OUT_DIR}/${NAME}.sfc"

${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${TMP_DIR}:
	mkdir -p ${TMP_DIR}

clean:
	rm -Rf ${TMP_DIR}

${ASAR_DIR}/src/asar/*:
	$(info Installing asar...)
	mkdir -p "${ASAR_DIR}"
	wget -c "${ASAR_URL}" -O - | tar -xz --strip-components=1 -C "${ASAR_DIR}"

${ASAR_DIR}/asar/bin/${ASAR_EXECUTABLE}: ${ASAR_DIR}/src/asar/*
	cd "${ASAR_DIR}" && ${CMAKE} src -G "${CMAKE_ASAR_GENERATOR}" > /dev/null && ${CMAKE} --build .

.PHONY: clean asar ${NAME} build debug rm_asar force_update_asar
.SILENT: build asar