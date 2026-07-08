pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as KirigamiComponents
import org.kde.config as KConfig
import org.kde.coreaddons as KCoreAddons

PlasmoidItem {
    id: root

    readonly property bool showIcon: true
    readonly property string icon: "terminal"
    readonly property bool showText: true

    readonly property bool isVertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical
    readonly property bool inPanel: (Plasmoid.location === PlasmaCore.Types.TopEdge || Plasmoid.location === PlasmaCore.Types.RightEdge || Plasmoid.location === PlasmaCore.Types.BottomEdge || Plasmoid.location === PlasmaCore.Types.LeftEdge)

    preferredRepresentation: compactRepresentation

    //toolTipTextFormat: Text.StyledText
    toolTipSubText: "Select a Script to run"

    compactRepresentation: Item {
        id: compactRoot
        implicitWidth: Kirigami.Units.gridUnit * 2
        implicitHeight: implicitWidth
        PlasmaComponents.ToolButton {
            anchors.fill: parent
            icon.name: "workflowy"

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
                        console.log("Restart VPN clicked");
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
                    onClicked: console.log("check updates")
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
                    icon.name: stackView.currentItem && stackView.currentItem.icon !== undefined ? stackView.currentItem.icon : "workflowy"
                    Layout.fillWidth: true
                    hoverEnabled: false
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
                        duration: Kirigami.Units.longDuration
                    }
                }
                pushExit: Transition {
                    PropertyAnimation {
                        property: "x"
                        from: 0
                        to: -stackView.width
                        duration: Kirigami.Units.longDuration
                    }
                }
                popEnter: Transition {
                    PropertyAnimation {
                        property: "x"
                        from: -stackView.width
                        to: 0
                        duration: Kirigami.Units.longDuration
                    }
                }
                popExit: Transition {
                    PropertyAnimation {
                        property: "x"
                        from: 0
                        to: stackView.width
                        duration: Kirigami.Units.longDuration
                    }
                }
            }
        }
    }
}
