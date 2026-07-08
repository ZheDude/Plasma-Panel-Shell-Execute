pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.notification as Notification

PlasmoidItem {
    id: root

    readonly property string icon: "terminal"

    readonly property bool isVertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical
    readonly property bool inPanel: (Plasmoid.location === PlasmaCore.Types.TopEdge || Plasmoid.location === PlasmaCore.Types.RightEdge || Plasmoid.location === PlasmaCore.Types.BottomEdge || Plasmoid.location === PlasmaCore.Types.LeftEdge)

    preferredRepresentation: compactRepresentation

    //toolTipTextFormat: Text.StyledText
    toolTipSubText: "Select a Script to run"
    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []

        property var callbacks: ({})

        function exec(cmd, callback) {
            const sourceName = cmd + " #" + Date.now() + Math.random();
            if (callback)
                callbacks[sourceName] = callback;
            connectSource(sourceName);
            return sourceName;
        }

        onNewData: (sourceName, data) => {
            if (callbacks[sourceName]) {
                callbacks[sourceName](data);
                delete callbacks[sourceName];
            }
            disconnectSource(sourceName);
        }
    }
    Component {
        id: notificationComponent
        Notification.Notification {
            componentName: "plasma_workspace"
            eventId: "notification"
            autoDelete: true   // clean up the QML object once it's closed
        }
    }

    function runCommand(cmd, label, timeoutMs = 60000) {
        // 1. Create + show a "running" notification
        const notif = notificationComponent.createObject(root, {
            title: label,
            text: "Running…",
            iconName: "system-run",
            flags: Notification.Notification.Persistent // stays open until we update it
        });
        notif.sendEvent();

        let finished = false;
        let sourceName = "";

        const timeoutTimer = Qt.createQmlObject('import QtQuick; Timer { interval: ' + timeoutMs + '; running: true; repeat: false }', root);
        timeoutTimer.triggered.connect(function () {
            if (!finished) {
                finished = true;
                executable.disconnectSource(sourceName);
                delete executable.callbacks[sourceName];
                notif.text = "Timed out waiting for authentication";
                notif.iconName = "dialog-error";
                notif.flags = Notification.Notification.CloseOnTimeout;
                notif.sendEvent();
            }
            timeoutTimer.destroy();
        });

        sourceName = executable.exec(cmd, function (data) {
            if (finished)
                return;
            finished = true;
            timeoutTimer.stop();
            const success = data["exit code"] === 0;
            notif.text = success ? "Completed successfully" : "Failed (exit " + data["exit code"] + "): " + data["stderr"];
            notif.iconName = success ? "dialog-ok" : "dialog-error";
            notif.flags = Notification.Notification.CloseOnTimeout;
            notif.sendEvent();
        });
    }

    compactRepresentation: Item {
        id: compactRoot
        implicitWidth: Kirigami.Units.gridUnit * 2
        implicitHeight: implicitWidth
        PlasmaComponents.ToolButton {
            anchors.fill: parent
            icon.name: "terminal"

            onClicked: {
                console.log("clicked");
                root.expanded = !root.expanded;
            }
        }
    }

    fullRepresentation: Item {
        id: fullRoot

        implicitWidth: mainColumn.implicitWidth
        implicitHeight: mainColumn.implicitHeight

        Layout.preferredWidth: implicitWidth
        Layout.preferredHeight: implicitHeight
        Layout.minimumWidth: Layout.preferredWidth
        Layout.minimumHeight: Layout.preferredHeight
        Layout.maximumWidth: Layout.preferredWidth
        Layout.maximumHeight: Layout.preferredHeight

        Component {
            id: mainMenuPage
            ColumnLayout {
                spacing: 0
                PlasmaComponents.ItemDelegate {
                    text: "Update"
                    icon.name: "system-software-update"
                    Layout.fillWidth: true
                    onClicked: stackView.push(updateSubMenu)
                }
                PlasmaComponents.ItemDelegate {
                    text: "Backup"
                    icon.name: "document-save"
                    Layout.fillWidth: true
                    onClicked: stackView.push(backupSubMenu)
                }
                PlasmaComponents.ItemDelegate {
                    text: "Restart VPN"
                    icon.name: "network-vpn"
                    Layout.fillWidth: true
                    onClicked: {
                        root.runCommand("pkexec whoami", "Test Auth");
                        root.expanded = false;
                    }
                }
            }
        }

        // "Update" submenu
        Component {
            id: updateSubMenu
            ColumnLayout {
                spacing: 0
                property string title: "Update"
                property string icon: "system-software-update"
                PlasmaComponents.ItemDelegate {
                    text: "Check for Updates"
                    icon.name: "view-refresh"
                    Layout.fillWidth: true
                    onClicked: root.runCommand("konsole -e bash -c 'sudo dnf update'", "Updating", 120000)
                }
                PlasmaComponents.ItemDelegate {
                    text: "Update Now"
                    icon.name: "system-software-update"
                    Layout.fillWidth: true
                    onClicked: console.log("update now")
                }
            }
        }

        // "Backup" submenu
        Component {
            id: backupSubMenu
            ColumnLayout {
                property string title: "Backup"
                property string icon: "document-save"
                spacing: 0
                PlasmaComponents.ItemDelegate {
                    text: "Backup Now"
                    icon.name: "document-save"
                    Layout.fillWidth: true
                    onClicked: console.log("backup now")
                }
                PlasmaComponents.ItemDelegate {
                    text: "Restore"
                    icon.name: "edit-undo"
                    Layout.fillWidth: true
                    onClicked: console.log("restore")
                }
            }
        }

        // -------- Layout: header (back button + title) + stack --------
        ColumnLayout {
            id: mainColumn
            anchors.fill: parent
            spacing: 0

            RowLayout {
                id: headerRow
                Layout.fillWidth: true
                Layout.preferredHeight: implicitHeight

                PlasmaComponents.ToolButton {
                    icon.name: "go-previous"
                    onClicked: stackView.pop()
                    visible: stackView.depth > 1
                }
                PlasmaComponents.ItemDelegate {
                    text: stackView.currentItem && stackView.currentItem.title !== undefined ? stackView.currentItem.title : "Workflow"
                    icon.name: stackView.currentItem && stackView.currentItem.icon !== undefined ? stackView.currentItem.icon : "terminal"
                    Layout.fillWidth: true
                    hoverEnabled: false
                    onClicked: stackView.depth > 1 ? stackView.pop() : null
                }
            }

            QQC2.StackView {
                id: stackView
                Layout.fillWidth: true
                implicitWidth: currentItem ? currentItem.implicitWidth : 0
                implicitHeight: currentItem ? currentItem.implicitHeight : 0
                initialItem: mainMenuPage

                pushEnter: Transition {
                    PropertyAnimation {
                        property: "x"
                        from: stackView.width
                        to: 0
                        duration: Kirigami.Units.longDuration * 1.4
                    }
                }
                pushExit: Transition {
                    PropertyAnimation {
                        property: "x"
                        from: 0
                        to: -stackView.width
                        duration: Kirigami.Units.longDuration * 1.4
                    }
                }
                popEnter: Transition {
                    PropertyAnimation {
                        property: "x"
                        from: -stackView.width
                        to: 0
                        duration: Kirigami.Units.longDuration * 1.4
                    }
                }
                popExit: Transition {
                    PropertyAnimation {
                        property: "x"
                        from: 0
                        to: stackView.width
                        duration: Kirigami.Units.longDuration * 1.4
                    }
                }
            }
        }
    }
}
