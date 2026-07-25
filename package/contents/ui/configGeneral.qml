import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import QtQuick.Layouts
import org.kde.iconthemes as KIconThemes

Kirigami.FormLayout {
    id: generalPage
    Layout.fillWidth: true

    property alias cfg_icon: icon.text
    property string cfg_iconDefault

    Kirigami.Heading {
        text: "Select an Icon"
    }

    RowLayout {
        Kirigami.FormData.label: "Icon:"

        QQC2.TextField {
            id: icon
            implicitWidth: 300
        }

        QQC2.Button {
            icon.name: "folder"
            onClicked: {
                iconDialog.open();
            }
        }
    }

    Item {
        Kirigami.FormData.isSection: true
    }

    KIconThemes.IconDialog {
        id: iconDialog

        onIconNameChanged: iconName => {
            generalPage.cfg_icon = iconName;
        }
    }

    Kirigami.Heading {
        text: "Backup"
        level: 1
        Kirigami.FormData.isSection: true
    }

    property string cfg_backupCommand
    property string cfg_backupCommandDefault

    property var commandList: []

    Component.onCompleted: {
        try {
            commandList = JSON.parse(cfg_backupCommand);
            console.log(commandList);
        } catch (e) {
            commandList = [];
        }
    }

    function saveList() {
        cfg_backupCommand = JSON.stringify(commandList);
    }

    GridLayout {
        width: generalPage.width
        Layout.fillWidth: true

        QQC2.Label {
            text: "Manual Entries:"
        }

        QQC2.Button {
            text: "Add Entry"
            icon.name: "list-add"
            onClicked: {
                generalPage.commandList.push({
                    label: "New",
                    iconName: "google-drive",
                    commandString: ""
                });
                generalPage.commandList = generalPage.commandList.slice();
                generalPage.saveList();
            }
        }
    }
    ColumnLayout {
        Repeater {
            model: generalPage.commandList
            delegate: RowLayout {
                required property var modelData
                required property int index
                QQC2.TextField {
                    text: generalPage.modelData.label
                    placeholderText: "Label"
                    onEditingFinished: {
                        generalPage.commandList[index].label = text;
                        generalPage.saveList();
                    }
                }
                QQC2.TextField {
                    text: modelData.commandString
                    placeholderText: "Command"
                    onEditingFinished: {
                        generalPage.commandList[index].commandString = text;
                        generalPage.saveList();
                    }
                }
                QQC2.ToolButton {
                    icon.name: "list-remove"
                    onClicked: {
                        generalPage.commandList.splice(index, 1);
                        generalPage.commandList = generalPage.commandList.slice();
                        generalPage.saveList();
                    }
                }
            }
        }
    }
}
