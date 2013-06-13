APP_NAME = ECL

CONFIG += qt warn_on cascades10

LIBS += -lbbdata
LIBS += -lbbsystem
LIBS += -lbb
LIBS += -lbbpim
LIBS += -lbbnetwork
LIBS += -lbbplatform

BASEDIR =  $$quote($$_PRO_FILE_PWD_)

INCLUDEPATH += \
         $$quote(${QNX_TARGET}/usr/include/bb/device) \
         $$quote(${QNX_TARGET}/usr/include/bb/data)

DEPENDPATH += $$quote(${QNX_TARGET}/usr/include/bb/device) \
         $$quote(${QNX_TARGET}/usr/include/bb/data)


INCLUDEPATH += ../src ../src/pushclient
SOURCES += ../src/*.cpp ../src/pushclient/*.cpp
HEADERS += ../src/*.hpp ../src/*.h ../src/pushclient/*.hpp ../src/pushclient/*.h

lupdate_inclusion {
    SOURCES += ../assets/*.qml
}

TRANSLATIONS =  $$quote($${TARGET}.ts)
