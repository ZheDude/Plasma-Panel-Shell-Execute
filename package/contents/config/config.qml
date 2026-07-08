import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: "General"
        icon: "configure"
        source: "configGeneral.qml"
    }
    ConfigCategory {
        name: "Updates"
        icon: "system-software-update"
        source: "configUpdate.qml"
    }
    ConfigCategory {
        name: "Backup"
        icon: "document-save"
        source: "configBackup.qml"
    }
    ConfigCategory {
        name: "Docker"
        icon: "docker-desktop"
        source: "configDocker.qml"
    }
}
