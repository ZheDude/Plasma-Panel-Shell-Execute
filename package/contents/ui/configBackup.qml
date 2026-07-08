pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: page

    property string cfg_backupCommand: "[]"

    property var commandList: []

    Component.onCompleted: {
        try {
            commandList = JSON.parse(cfg_backupCommand);
        } catch (e) {
            commandList = [];
        }
    }

    function saveList() {
        cfg_backupCommand = JSON.stringify(commandList);
    }

    ColumnLayout {
        Kirigami.FormData.label: "Manual Entries:"

        Repeater {
            model: page.commandList
            delegate: RowLayout {
                required property var modelData
                required property int index
                QQC2.TextField {
                    text: modelData.label
                    placeholderText: "Label"
                    onEditingFinished: {
                        page.commandList[index].label = text;
                        page.saveList();
                    }
                }
                QQC2.TextField {
                    text: modelData.containerName
                    placeholderText: "Command"
                    onEditingFinished: {
                        page.commandList[index].containerName = text;
                        page.saveList();
                    }
                }
                QQC2.ToolButton {
                    icon.name: "list-remove"
                    onClicked: {
                        page.commandList.splice(index, 1);
                        page.commandList = page.commandList.slice();
                        page.saveList();
                    }
                }
            }
        }

        QQC2.Button {
            text: "Add Entry"
            icon.name: "list-add"
            onClicked: {
                page.commandList.push({
                    label: "New",
                    iconName: "docker-desktop",
                    containerName: ""
                });
                page.commandList = page.commandList.slice();
                page.saveList();
            }
        }
    }
}
