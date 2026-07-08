pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as KirigamiComponents
import org.kde.config as KConfig  // KAuthorized.authorizeControlModule
import org.kde.coreaddons as KCoreAddons // kuser

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
            icon.name: "folder"

            onClicked: {
                console.log("clicked");
                root.expanded = !root.expanded;
            }
        }
    }

    fullRepresentation: Item {
        id: fullRoot

        implicitHeight: column.implicitHeight
        implicitWidth: column.implicitWidth

        Layout.preferredWidth: root.showText ? Kirigami.Units.gridUnit * 12 : Kirigami.Units.iconSizes.smallMedium * 1.6
        Layout.preferredHeight: implicitHeight
        Layout.minimumWidth: Layout.preferredWidth
        Layout.minimumHeight: Layout.preferredHeight
        Layout.maximumWidth: Layout.preferredWidth
        Layout.maximumHeight: Layout.preferredHeight

        ColumnLayout {
            id: column

            anchors.fill: parent
            spacing: 0

            PlasmaComponents.ScrollView {
                id: scroll

                Layout.fillWidth: true
                Layout.fillHeight: true

                PlasmaComponents.ScrollBar.horizontal.policy: PlasmaComponents.ScrollBar.AlwaysOff
                ColumnLayout {
                    width: parent.width

                    PlasmaComponents.ItemDelegate {
                        text: "Update"
                        icon.name: "system-software-update"
                    }

                    PlasmaComponents.ItemDelegate {
                        text: "Backup"
                        icon.name: "document-save"
                    }

                    PlasmaComponents.ItemDelegate {
                        text: "Restart VPN"
                        icon.name: "network-vpn"
                    }
                }
            }
        }
    }
}
