APP_NAME = brewmaster

CONFIG += qt warn_on cascades10
LIBS += -lbbdevice -lbbsystem -lbbdata -lscreen -lbbnetwork -lbbplatform -lbps -lbb -lbbcascadesmaps -lGLESv1_CM -lQtLocationSubset -lbbplatformbbm

include(config.pri)

device {
    CONFIG(debug, debug|release) {
        # Device-Debug custom configuration
    }

    CONFIG(release, debug|release) {
        # Device-Release custom configuration
    }
}

simulator {
    CONFIG(debug, debug|release) {
        # Simulator-Debug custom configuration
    }
}
